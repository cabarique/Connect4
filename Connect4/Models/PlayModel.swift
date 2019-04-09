//
//  PlayModel.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/8/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import Foundation

protocol Play {
    var player: Player { get }
    var column: Int { get }
    var row: Int { get }
}

struct PlayModel: Play {
    var player: Player
    var column: Int
    var row: Int
}
