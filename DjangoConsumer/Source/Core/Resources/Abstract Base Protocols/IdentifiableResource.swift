//
//  IdentifiableResource.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 27.04.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//


// MARK: // Public
// MARK: - IdentifiableResource
public protocol IdentifiableResource: DetailResource {
    var id: ResourceID<Self>? { get }
}


// MARK: - IdentifiableResourceError
public enum IdentifiableResourceError: Error {
    case hasNoID
}
