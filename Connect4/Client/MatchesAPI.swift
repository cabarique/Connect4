//
//  MatchesAPI.swift
//  Connect4
//
//  Created by Luis Cabarique on 4/10/19.
//  Copyright © 2019 Luis Cabarique. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseDatabase

protocol MatchesAPI {
    func addMatch(_ match: Match) -> Observable<Void>
    func getMatches() -> Observable<[Match]>
}

struct MatchesAPIImp: MatchesAPI {
    private var database: DatabaseReference!
    
    init() {
        database = Database.database().reference().child("matches")
    }
    
    func addMatch(_ match: Match) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            self.database
                .childByAutoId()
                .setValue(match.toAny()) { (error, reference) in
                    if let error = error { observer.onError(error) }
                    else {
                        observer.onNext(())
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }
    }
    
    func getMatches() -> Observable<[Match]> {
        
        return Observable.create { observer -> Disposable in
            self.database.observe(DataEventType.value) { (snapshot, something) in
                if let matchesDictionary = snapshot.value as? [String: [String: AnyObject]] {
                    let matches = matchesDictionary.compactMap { match in
                        MatchModel(data: match.value)
                    }
                    observer.onNext(matches)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
