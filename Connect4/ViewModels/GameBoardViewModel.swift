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
    
    //Subjects
    fileprivate let player1NameSubject = ReplaySubject<String>.create(bufferSize: 1)
    fileprivate let player2NameSubject = ReplaySubject<String>.create(bufferSize: 1)
    
    init() {
        player1NameSubject.onNext("Player 1")
        player2NameSubject.onNext("Player 2")
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
