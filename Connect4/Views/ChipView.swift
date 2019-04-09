//
//  ChipView.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/9/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import UIKit

class ChipView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        clipsToBounds = true
        layer.cornerRadius = rect.width / 2
    }
    
}
