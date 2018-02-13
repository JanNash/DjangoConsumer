//
//  DetailGettableClient.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 13.02.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
public protocol DetailGettableClient: class {
    func gotObject(object: DetailGettable)
    func failedGettingObject(_ object: DetailGettable, with error: Error)
}
