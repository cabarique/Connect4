//
//  MatchesTableViewController.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/10/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import UIKit

class MatchesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as! MatchTableViewCell
        cell.redScoreLabel.text = "4"
        cell.yellowScoreLabel.text = "3"
        cell.redPlayerNameLabel.text = "Luis"
        cell.yellowPlayerNameLabel.text = "Fernando"
        cell.winLabel.text = "Luis Wins!"
        return cell
    }

}
