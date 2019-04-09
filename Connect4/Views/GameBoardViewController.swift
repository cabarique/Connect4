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
    
    //MARK: IBOutlets
    @IBOutlet weak var boardCollectionView: UICollectionView!
    @IBOutlet weak var boardContainerView: UIView!
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player2Label: UILabel!
    
    override func viewDidLoad() {
        boardCollectionView.register(SlotViewCell.self, forCellWithReuseIdentifier: SlotViewCell.cellReuseIdentifier())
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 7
        return CGSize(width: width, height: width)
    }
    
}
