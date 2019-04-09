//
//  ChipModel.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/8/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import Foundation

enum ChipType {
    case red
    case yellow
    case blank
}

protocol Chip {
    var type: ChipType { get }
}

struct ChipModel: Chip {
    var type: ChipType
}
