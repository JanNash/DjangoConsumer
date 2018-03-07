//
//  Filtering.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 18.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: - FilterKey & FilterComparator defaults
//
// To define custom keys, FilterKey/FilterComparator should be extended
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
// via a pull request against https://github.com/JanNash/DjangoConsumer.git


// // // The pattern starts // // //

// MARK: - FilterKey defaults
public extension FilterKey {
    public static var date: FilterKey<Date>      { return _K<Date>(.date) }
    public static var id: FilterKey<id_Type>     { return _K<id_Type>(.id) }
    public static var name: FilterKey<String>    { return _K<String>(.name) }
    
    // Helpers
    private typealias _K<V> = FilterKey<V>
    
    enum DefaultFilterKeys: String {
        case date   = "date"
        case id     = "id"
        case name   = "name"
    }
}


// MARK: - FilterKey Special Types
public protocol id_Type {}


// MARK: - FilterComparator defaults
public extension FilterComparator {
    public static var __lt: FilterComparator         { return _C(.__lt) }
    public static var __lte: FilterComparator        { return _C(.__lte) }
    public static var __gte: FilterComparator        { return _C(.__gte) }
    public static var __gt: FilterComparator         { return _C(.__gt) }
    public static var __in: FilterComparator         { return _C(.__in) }
    public static var __icontains: FilterComparator  { return _C(.__icontains) }
    
    // Helpers
    // The class name is simply too long...
    private typealias _C = FilterComparator
    
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


// MARK: - FilterType
// This is needed, so it's possible to create Arrays
// containing Filters with different generic types
public protocol FilterType {
    var stringKey: String { get }
    var value: Any? { get }
}


// MARK: - Filter Struct Declaration
// ???: Is this typealias a good idea? Does it clutter someones namespace?
// Technically, it's DjangoConsumer._F, so it should be fine, I hope?
public typealias _F<V> = Filter<V>
public struct Filter<V>: FilterType {
    // Init
    public init(_ key: FilterKey<V>, _ comparator: FilterComparator, _ value: V) {
        self.key = key
        self.comparator = comparator
        self.value = value
    }
    
    // FilterType Conformance
    public var stringKey: String {
        return self.key.string + self.comparator.string
    }
    
    // Public Readonly Variables
    public private(set) var key: FilterKey<V>
    public private(set) var comparator: FilterComparator
    public private(set) var value: Any?
}


// MARK: - FilterKey Struct Declaration
public struct FilterKey<V>: Equatable {
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
    func __<T>(_ keyToAppend: FilterKey<T>) -> FilterKey<T> {
        return FilterKey<T>(self.string + "__" + keyToAppend.string)
    }
    
    // Equatability
    public static func ==<T>(_ lhs: FilterKey<T>, _ rhs: FilterKey<T>) -> Bool {
        return lhs.string == rhs.string
    }
    
    public static func !=<T>(_ lhs: FilterKey<T>, _ rhs: FilterKey<T>) -> Bool {
        return lhs.string != rhs.string
    }
}


// MARK: - FilterComparator Struct Declaration
public struct FilterComparator: Equatable {
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
    public static func ==(_ lhs: FilterComparator, _ rhs: FilterComparator) -> Bool {
        return lhs.string == rhs.string
    }
    
    public static func !=(_ lhs: FilterComparator, _ rhs: FilterComparator) -> Bool {
        return lhs.string != rhs.string
    }
}
