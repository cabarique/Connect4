//
//  PlayerModel.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/8/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import Foundation

protocol Player {
    var name: String { get }
    var score: Int { set get }
    var chip: Chip { get }
    func isEqual(player: Player) -> Bool
    func toAny() -> Any
    mutating func incrementScore()
}

extension Player {
    func isEqual(player: Player) -> Bool {
        return self.name == player.name
            && self.score == player.score
            && self.chip.type == player.chip.type
    }
}

struct PlayerModel: Player {
    var name: String
    var score: Int
    var chip: Chip
    
    init(name: String, score: Int, chip: Chip) {
        self.name = name
        self.score = score
        self.chip = chip
    }
    
    init?(data: [String: AnyObject], chipColor: ChipType) {
        guard
            let name = data["name"] as? String,
            let score = data["score"] as? Int
            else {
                return nil
        }
        self.name = name
        self.score = score
        self.chip = ChipModel(type: chipColor)
    }
    
    func toAny() -> Any {
        return ["name": name,
                "score": score]
    }
    
    mutating func incrementScore() {
        score += 1
    }
}
