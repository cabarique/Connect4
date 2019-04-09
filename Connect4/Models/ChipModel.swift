//
//  ChipModel.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/8/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import Foundation
import UIKit

enum ChipType {
    case red
    case yellow
    case blank
    
    func color() -> UIColor {
        switch self {
        case .blank:
            return UIColor.clear
        case .yellow:
            return UIColor(named: "C4Yellow")!
        case .red:
            return UIColor(named: "C4Red")!
        }
    }
}

protocol Chip {
    var type: ChipType { get }
}

struct ChipModel: Chip {
    var type: ChipType
}
