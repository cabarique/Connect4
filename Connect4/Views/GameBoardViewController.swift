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
    
    private let disposeBag = DisposeBag()
    let viewModel = GameBoardViewModel()
    
    //MARK: IBOutlets
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player2Label: UILabel!
    
    override func viewDidLoad() {
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
