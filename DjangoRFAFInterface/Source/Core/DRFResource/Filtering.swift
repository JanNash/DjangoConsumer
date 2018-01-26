//
//  Filtering.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: - DRFFilterKey & DRFFilterComparator defaults
//
// To define custom keys, DRFFilterKey/DRFFilterComparator should be extended
// the same way as here. Ideally, the enum should be named 'CustomFilterKeys'
// but technically it can be named arbitrarily. An enum is preferred to a struct
// for these keys because it guarantees uniqueness of its raw values.
// This funny pattern is used so a filter can be written like this:
//
// >>> let now: Date = Date()
// >>> _F(.date, .__gte, now)
//
// I'm still searching for a way to make the comparator protocol typesafe
// (within reason) but haven't found a working one yet. If you know how,
// please feel free to send me an email (jnash<at}jnash[dot)de) or
// submit a pull request. You can also submit addition requests to these Defaults
// via a pull request against https://github.com/JanNash/DjangoRFAFInterface.git


// // // The pattern starts // // //

// MARK: - DRFFilterKey defaults
public extension DRFFilterKey {
    public static var date: DRFFilterKey<Date>      { return _K<Date>(.date) }
    public static var id: DRFFilterKey<id_Type>     { return _K<id_Type>(.id) }
    public static var name: DRFFilterKey<String>    { return _K<String>(.name) }
    
    // Helpers
    private typealias _K<V> = DRFFilterKey<V>
    
    enum DefaultFilterKeys: String {
        case date   = "date"
        case id     = "id"
        case name   = "name"
    }
}


// MARK: - DRFFilterKey Special Types
public protocol id_Type {}


// MARK: - DRFFilterComparator defaults
public extension DRFFilterComparator {
    public static var __lt: DRFFilterComparator         { return _C(.__lt) }
    public static var __lte: DRFFilterComparator        { return _C(.__lte) }
    public static var __gte: DRFFilterComparator        { return _C(.__gte) }
    public static var __gt: DRFFilterComparator         { return _C(.__gt) }
    public static var __in: DRFFilterComparator         { return _C(.__in) }
    public static var __icontains: DRFFilterComparator  { return _C(.__icontains) }
    
    // Helpers
    // The class name is simply too long...
    private typealias _C = DRFFilterComparator
    
    enum DefaultFilterComparators: String {
        case __lt           = "__lt"
        case __lte          = "__lte"
        case __gte          = "__gte"
        case __gt           = "__gt"
        case __in           = "__in"
        case __icontains    = "__icontains"
    }
}

// // // The pattern ends // // //


// MARK: - DRFFilter Struct Declaration
// ???: Is this typealias a good idea? Does it clutter someones namespace?
// Technically, it's DjangoRFAFInterface._F, so it should be fine, I hope?
public typealias _F = DRFFilter
public struct DRFFilter<V> {
    // Init
    public init(_ key: DRFFilterKey<V>, _ comparator: DRFFilterComparator, _ value: V) {
        self.key = key
        self.comparator = comparator
        self.value = value
    }
    
    // Public Readonly Variables
    public private(set) var key: DRFFilterKey<V>
    public private(set) var comparator: DRFFilterComparator
    public private(set) var value: Any?
}


// MARK: - DRFFilterKey Struct Declaration
public struct DRFFilterKey<V>: Equatable {
    // Public Init
    public init(_ string: String) {
        self.string = string
    }
    
    // Private Init
    private init(_ defaultFilterKey: DefaultFilterKeys) {
        self.string = defaultFilterKey.rawValue
    }
    
    // Readonly
    private(set) var string: String
    
    // Functions
    // Key Concatenation
    func __<T>(_ keyToAppend: DRFFilterKey<T>) -> DRFFilterKey<T> {
        return DRFFilterKey<T>(self.string + "__" + keyToAppend.string)
    }
    
    // Equatability
    public static func ==<T>(_ lhs: DRFFilterKey<T>, _ rhs: DRFFilterKey<T>) -> Bool {
        return lhs.string == rhs.string
    }
    
    public static func !=<T>(_ lhs: DRFFilterKey<T>, _ rhs: DRFFilterKey<T>) -> Bool {
        return lhs.string != rhs.string
    }
}


// MARK: - DRFFilterComparator Struct Declaration
public struct DRFFilterComparator: Equatable {
    // Public Init
    public init(_ string: String) {
        self.string = string
    }
    
    // Private Init
    private init(_ defaultFilterComparator: DefaultFilterComparators) {
        self.string = defaultFilterComparator.rawValue
    }
    
    // Readonly
    private(set) var string: String
    
    // Equatability
    public static func ==(_ lhs: DRFFilterComparator, _ rhs: DRFFilterComparator) -> Bool {
        return lhs.string == rhs.string
    }
    
    public static func !=(_ lhs: DRFFilterComparator, _ rhs: DRFFilterComparator) -> Bool {
        return lhs.string != rhs.string
    }
}
