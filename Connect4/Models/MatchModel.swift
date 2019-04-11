//
//  MatchModel.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/10/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import Foundation

protocol Match {
    var winner: String { get }
    var red: Player { get }
    var yellow: Player { get }
    var timeStamp: Date { get }
    
    func toAny() -> Any
}

struct MatchModel: Match {
    var winner: String
    var red: Player
    var yellow: Player
    var timeStamp: Date = Date()
    
    func toAny() -> Any {
        return ["winner": winner,
                "red": red.toAny(),
                "yellow": yellow.toAny(),
                "timeStamp": timeStamp.millisecondsSince1970 ]
    }
    
    init(winner: String, red: Player, yellow: Player, timeStamp: Date) {
        self.winner = winner
        self.red = red
        self.yellow = yellow
        self.timeStamp = timeStamp
    }
    
    init?(data: [String: AnyObject]) {
        guard
            let winner = data["winner"] as? String,
            let redData = data["red"] as? [String: AnyObject],
            let redPlayer = PlayerModel(data: redData, chipColor: .red),
            let yellowData = data["yellow"] as? [String: AnyObject],
            let yellowPlater = PlayerModel(data: yellowData, chipColor: .yellow),
            let timeStamp = data["timeStamp"] as? Int
            else {
                return nil
        }
        
        self.winner = winner
        self.red = redPlayer
        self.yellow = yellowPlater
        self.timeStamp = Date.init(milliseconds: timeStamp)
    }
}
