//
//  GameBoardViewModel.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/8/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol GameBoardViewModelOutput {
    var player1NameObservable: Observable<String> { get }
    var player2NameObservable: Observable<String> { get }
    var playerTurn: BehaviorRelay<Player> { get }
}

class GameBoardViewModel {
    let disposeBag = DisposeBag()
    
    static let boardWidth = 7
    static let boardHeight = 6
    
    var gameBoard: [[Chip]] =  Array(repeating: Array(repeating: ChipModel(type: .blank), count: boardWidth), count: boardHeight)
    
    //Subjects
    fileprivate let player1NameSubject = ReplaySubject<String>.create(bufferSize: 1)
    fileprivate let player2NameSubject = ReplaySubject<String>.create(bufferSize: 1)
    fileprivate let player1Subject: BehaviorRelay<Player>
    fileprivate let player2Subject: BehaviorRelay<Player>
    let playerTurn: BehaviorRelay<Player>
    
    init() {
        //setup player 1
        let player1 = PlayerModel(name: "Player 1", score: 0, chip: ChipModel(type: .red))
        player1Subject = BehaviorRelay(value: player1)
        playerTurn = BehaviorRelay(value: player1)
        
        //setup player 2
        let player2 = PlayerModel(name: "Player 2", score: 0, chip: ChipModel(type: .yellow))
        player2Subject = BehaviorRelay(value: player2)
        
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
            player1Subject.accept(newPlayer)
        case .yellow:
            player2Subject.accept(newPlayer)
        default:
            break
        }
    }
    
    func newPlay(_ play: Play) {
        gameBoard[play.row][play.column] = playerTurn.value.chip
        nextPlayer()
    }
    
    func nextPlay(column: Int) -> Play? {
        for row in (0..<GameBoardViewModel.boardHeight).reversed() {
            if gameBoard[row][column].type == .blank {
                gameBoard[row][column] = playerTurn.value.chip
                return PlayModel(player: playerTurn.value, column: column, row: row)
            }
        }
        return nil
    }
    
    private func nextPlayer() {
        if player1Subject.value.isEqual(player: playerTurn.value) {
            playerTurn.accept(player2Subject.value)
        } else if player2Subject.value.isEqual(player: playerTurn.value) {
            playerTurn.accept(player1Subject.value)
        }else {
            fatalError("player not found")
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
