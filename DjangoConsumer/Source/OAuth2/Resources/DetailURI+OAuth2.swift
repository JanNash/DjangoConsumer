//
//  DetailURI+OAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 13.02.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: where T: DetailGettable & NeedsOAuth2
public extension DetailURI where T: DetailGettable & NeedsOAuth2 {
    func get(from node: OAuth2Node = T.defaultNode) {
        self.get_(from: node)
    }
}
