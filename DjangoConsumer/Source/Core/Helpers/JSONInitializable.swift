//
//  JSONInitializable.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 08.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import SwiftyJSON


// MARK: // Public
public protocol JSONInitializable {
    init(json: JSON)
}
