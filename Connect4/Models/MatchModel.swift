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
}
