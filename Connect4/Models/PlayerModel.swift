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
}

struct PlayerModel: Player {
    var name: String
    var score: Int
    var chip: Chip
}
