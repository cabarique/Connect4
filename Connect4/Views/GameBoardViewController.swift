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
            .bind(to: player1Label.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .player2NameObservable
            .bind(to: player2Label.rx.text)
            .disposed(by: disposeBag)
    }
}
