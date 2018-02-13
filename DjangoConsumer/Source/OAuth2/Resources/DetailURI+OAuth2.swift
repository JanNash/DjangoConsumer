//
//  DetailURI+OAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 13.02.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: where T: DetailGettable & NeedsOAuth2
public extension DetailURI where T: DetailGettable & NeedsOAuth2 {
    func get(from node: Node = T.defaultNode) {
        self.get_(from: node)
    }
}
