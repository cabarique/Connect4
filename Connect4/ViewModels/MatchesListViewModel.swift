//
//  MatchesListViewModel.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/10/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MatchesListViewModel {
    var api: MatchesAPI!
    let disposeBag = DisposeBag()
    
    var matches: BehaviorRelay<[Match]>
    
    init() {
        matches = BehaviorRelay(value: [])
    }
    
    func setAPI(_ api: MatchesAPI){
        self.api = api
        
        self.api.getMatches()
            .bind(to: matches)
            .disposed(by: self.disposeBag)
    }
}
