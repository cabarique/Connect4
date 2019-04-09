//
//  GameBoardViewController.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/8/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class GameBoardViewController: UIViewController {
    
    enum Config {
        static let collectionViewCellId = SlotViewCell.cellReuseIdentifier()
    }
    
    private let disposeBag = DisposeBag()
    let viewModel = GameBoardViewModel()
    var chipToPlayView: ChipView?
    
    //MARK: IBOutlets
    @IBOutlet weak var boardCollectionView: UICollectionView!
    @IBOutlet weak var boardContainerView: UIView!
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var boardGestureView: UIView!
    
    override func viewDidLoad() {
        boardCollectionView.register(SlotViewCell.self, forCellWithReuseIdentifier: SlotViewCell.cellReuseIdentifier())
        boardGestureView.isUserInteractionEnabled = true
        rxBind()
    }
    
    private func rxBind(){
        viewModel
            .player1NameObservable
            .observeOn(MainScheduler.instance)
            .bind(to: player1Label.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .player2NameObservable
            .observeOn(MainScheduler.instance)
            .bind(to: player2Label.rx.text)
            .disposed(by: disposeBag)
        
        player1Label.rx
            .tapGesture()
            .when(.recognized)
            .flatMap{ _ in self.showNewPlayerDialog()}
            .subscribe(onNext: { name in
                self.viewModel.newPlayer(name, chip: .red)
            })
            .disposed(by: disposeBag)
        
        player2Label.rx
            .tapGesture()
            .when(.recognized)
            .flatMap{ _ in self.showNewPlayerDialog()}
            .subscribe(onNext: { name in
                self.viewModel.newPlayer(name, chip: .yellow)
            })
            .disposed(by: disposeBag)
        
        boardGestureView.rx
            .anyGesture(
                (.tap(), when: .recognized),
                (.pan(), when: .began),
                (.pan(), when: .changed)
            )
            .map { gesture -> (column: Int, center: CGPoint) in
                let location = gesture.location(in: self.boardContainerView)
                return self.getColumn(location: location, in: self.boardContainerView)
            }
            .map { position -> UIView in
                if(self.chipToPlayView == nil) {
                    self.chipToPlayView = ChipView(frame: .zero)
                }
                
                self.chipToPlayView!.frame.size = CGSize(width: 40, height: 40)
                self.chipToPlayView!.center = position.center
                
                self.chipToPlayView!.backgroundColor = try! self.viewModel.playerTurn.value().chip.type.color()
                
                return self.chipToPlayView!
            }
            .subscribe(onNext: { chipView in
                if chipView.superview == nil {
                    self.boardContainerView.addSubview(chipView)
                    self.boardContainerView.sendSubviewToBack(chipView)
                }
            })
            .disposed(by: self.disposeBag)
        
            
    }
    
    /// gets column location plus center of the Chip
    private func getColumn(location: CGPoint, in view: UIView) -> (column: Int, center: CGPoint) {
        let column: Int
        
        let yAxis = view.bounds.origin.y
        let width = view.bounds.width
        let sectionWidth = width / CGFloat(GameBoardViewModel.boardWidth)
        let sectionDelta = sectionWidth / 2
        switch(location.x){
        case 0..<sectionWidth:
            column = 0
        case sectionWidth..<(2*sectionWidth):
            column = 1
        case (2*sectionWidth)..<(3*sectionWidth):
            column = 2
        case (3*sectionWidth)..<(4*sectionWidth):
            column = 3
        case (4*sectionWidth)..<(5*sectionWidth):
            column = 4
        case (5*sectionWidth)..<(6*sectionWidth):
            column = 5
        default:
            column = 6
        }
        let center: CGPoint = CGPoint(x: (CGFloat(column)*sectionWidth) + sectionDelta, y: yAxis)
        return (column, center)
    }
    
    private func showNewPlayerDialog() -> Observable<String> {
        let response = PublishSubject<String>()
        let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            response.onError(RxError.noElements)
        }))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your name here..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                response.onNext(name)
                response.onCompleted()
            }
        }))
        
        self.present(alert, animated: true)
        
        return response
    }
}

extension GameBoardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return GameBoardViewModel.boardHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GameBoardViewModel.boardWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Config.collectionViewCellId, for: indexPath) as! SlotViewCell
        
        let chip = viewModel.gameBoard[indexPath.section][indexPath.row]
        cell.state = chip.type
        cell.isUserInteractionEnabled = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 7
        return CGSize(width: width, height: width)
    }
    
}
