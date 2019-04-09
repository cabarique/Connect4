//
//  SlotViewCell.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/8/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import UIKit
import SnapKit
import Then

class SlotViewCell: UICollectionViewCell {
    
    enum config {
        static let padding: CGFloat = 6
        static let redChipColor = UIColor(named: "C4Red")!
        static let yellowChipColor = UIColor(named: "C4Yellow")!
        static let blankChipColor = UIColor.clear
        static let backgroundColor = UIColor(named: "C4Blue")!
    }
    
    var state: ChipType = .blank
    private var fillLayer: CAShapeLayer!
    private var chipView: UIView!
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        isUserInteractionEnabled = false
        self.fillLayer = CAShapeLayer().then {
            $0.fillRule = .evenOdd
            $0.fillColor = config.backgroundColor.cgColor
            layer.addSublayer($0)
        }
        
        self.chipView = UIView(frame: .zero).then {
            addSubview($0)
            clipsToBounds = true
            $0.backgroundColor = .clear
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.fillLayer.path = nil
        
        let radius = rect.size.width / 2 - config.padding
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height), cornerRadius: 0)
        let circleRect = CGRect(x: config.padding, y: config.padding, width: 2 * radius, height: 2 * radius)
        let circlePath = UIBezierPath(roundedRect: circleRect, cornerRadius: radius)
        path.append(circlePath)
        self.fillLayer.path = path.cgPath
        
        self.chipView.layer.cornerRadius = circleRect.size.width / 2
        self.chipView.frame = circleRect
        self.chipView.backgroundColor = state.color()
        
    }
}
