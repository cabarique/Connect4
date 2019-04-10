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
    var wonObservable: Observable<Player> { get }
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
    fileprivate let wonSubject = PublishSubject<Player>()
    
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
    
    func newGame(){
        gameBoard =  Array(repeating: Array(repeating: ChipModel(type: .blank), count: GameBoardViewModel.boardWidth), count: GameBoardViewModel.boardHeight)
    }
    
    /// adds a new player to the game
    func newPlayer(_ name: String, chip: ChipType) {
        let newPlayer = PlayerModel(name: name, score: 0, chip: ChipModel(type: chip))
        if playerTurn.value.chip.type == chip {
            playerTurn.accept(newPlayer)
        }
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
        if validateWin(play: play){
            print("player \(play.player.name) has won")
            wonSubject.onNext(play.player)
        }
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
    
    private func validateWin(play: Play) -> Bool {
        for row in 0..<GameBoardViewModel.boardHeight {
            for column in 0..<GameBoardViewModel.boardWidth {
                let currentPlay = PlayModel(player: play.player, column: column, row: row)
                if playWon(currentPlay) {
                    return true
                }
            }
        }
        
        return false
    }
    
    private func playWon(_ play: Play) -> Bool{
        return validateRight4(play) ||
            validateTop4(play) ||
            validateTopRight4(play) ||
            validateBottomRight4(play)
    }
    
    private func validateRight4(_ play: Play) -> Bool {
        if play.column + 4 > GameBoardViewModel.boardWidth { return false }
        
        for i in 0..<4 {
            if gameBoard[play.row][play.column + i].type != play.player.chip.type {
                return false
            }
        }
        print("won validateRight4 \(play)")
        return true
    }
    
    private func validateTop4(_ play: Play) -> Bool {
        if play.row + 4 > GameBoardViewModel.boardHeight { return false }
        
        for i in 0..<4 {
            if gameBoard[play.row + i][play.column].type != play.player.chip.type {
                return false
            }
        }
        print("won validateTop4 \(play)")
        return true
    }
    
    private func validateBottomRight4(_ play: Play) -> Bool {
        if play.column + 4 > GameBoardViewModel.boardWidth
            || play.row + 4 > GameBoardViewModel.boardHeight {
            return false
        }
        
        for i in 0..<4 {
            if gameBoard[play.row + i][play.column + i].type != play.player.chip.type {
                return false
            }
        }
        
        print("won validateBottomRight4 \(play)")
        return true
    }
    
    private func validateTopRight4(_ play: Play) -> Bool {
        if play.column + 4 > GameBoardViewModel.boardWidth
            || play.row - 3 < 0 {
            return false
        }
        
        for i in 0..<4 {
            if gameBoard[play.row - i][play.column + i].type != play.player.chip.type {
                return false
            }
        }
        print("won validateTopRight4 \(play)")
        return true
    }
}

extension GameBoardViewModel: GameBoardViewModelOutput {
    var wonObservable: Observable<Player> {
        return wonSubject.asObservable()
    }
    
    var player1NameObservable: Observable<String> {
        return player1NameSubject.asObservable()
    }
    
    var player2NameObservable: Observable<String> {
        return player2NameSubject.asObservable()
    }
}
