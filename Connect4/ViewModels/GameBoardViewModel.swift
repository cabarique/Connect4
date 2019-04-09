//
//  GameBoardViewModel.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/8/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import Foundation
import RxSwift

protocol GameBoardViewModelOutput {
    var player1NameObservable: Observable<String> { get }
    var player2NameObservable: Observable<String> { get }
}

class GameBoardViewModel {
    let disposeBag = DisposeBag()
    
    //Subjects
    fileprivate let player1NameSubject = ReplaySubject<String>.create(bufferSize: 1)
    fileprivate let player2NameSubject = ReplaySubject<String>.create(bufferSize: 1)
    fileprivate let player1Subject = ReplaySubject<Player>.create(bufferSize: 1)
    fileprivate let player2Subject = ReplaySubject<Player>.create(bufferSize: 1)
    
    init() {
        //setup player 1
        let player1 = PlayerModel(name: "Player 1", score: 0, chip: ChipModel(type: .red))
        player1Subject.onNext(player1)
        
        //setup player 2
        let player2 = PlayerModel(name: "Player 2", score: 0, chip: ChipModel(type: .yellow))
        player2Subject.onNext(player2)
        
        player1Subject
            .map{ $0.name}
            .bind(to: player1NameSubject)
            .disposed(by: disposeBag)
        
        player2Subject
            .map{ $0.name}
            .bind(to: player2NameSubject)
            .disposed(by: disposeBag)
    }
    
    /// adds a new player to the game
    func newPlayer(_ name: String, chip: ChipType) {
        let newPlayer = PlayerModel(name: name, score: 0, chip: ChipModel(type: chip))
        switch chip {
        case .red:
            player1Subject.onNext(newPlayer)
        case .yellow:
            player2Subject.onNext(newPlayer)
        }
    }
}

extension GameBoardViewModel: GameBoardViewModelOutput {
    var player1NameObservable: Observable<String> {
        return player1NameSubject.asObservable()
    }
    
    var player2NameObservable: Observable<String> {
        return player2NameSubject.asObservable()
    }
}
