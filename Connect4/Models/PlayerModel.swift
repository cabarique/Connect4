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
    var score: Int { get }
    var chip: Chip { get }
    func isEqual(player: Player) -> Bool
    func toAny() -> Any
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
    
    func toAny() -> Any {
        return ["name": name,
                "score": score]
    }
}
