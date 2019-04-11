//
//  MatchesTableViewController.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/10/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MatchesTableViewController: UITableViewController {
    let disposeBag = DisposeBag()
    let viewModel = MatchesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MATCHES"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
        
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        viewModel.setAPI(MatchesAPIImp())
        rxBind()
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
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
        return viewModel.matches.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as! MatchTableViewCell
        let match = viewModel.matches.value[indexPath.row]
        cell.redScoreLabel.text = "\(match.red.score)"
        cell.yellowScoreLabel.text = "\(match.yellow.score)"
        cell.redPlayerNameLabel.text = match.red.name
        cell.yellowPlayerNameLabel.text = match.yellow.name
        cell.winLabel.text = "\(match.winner) Wins!"
        return cell
    }
    
    func rxBind() {
        //Refreshes tableview
        viewModel.matches
            .asDriver()
            .drive(onNext: { _ in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

}
