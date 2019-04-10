//
//  MatchTableViewCell.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/10/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {

    @IBOutlet weak var redScoreLabel: UILabel!
    @IBOutlet weak var yellowScoreLabel: UILabel!
    @IBOutlet weak var redPlayerNameLabel: UILabel!
    @IBOutlet weak var yellowPlayerNameLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
