//
//  Filtering.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: - DRFFilter
// ???: Is this typealias a good idea? Does it clutter someones namespace?
// Technically, it's DjangoRFAFInterface._F, so it should be fine, I hope?
public typealias _F = DRFFilter
public struct DRFFilter<V> {
    // Init
    init(_ key: DRFFilterKey<V>, _ comparator: DRFFilterComparator<V>, _ value: V) {
        self.key = key
        self.comparator = comparator
        self.value = value
    }
    
    // Internal Readonly Variables
    private(set) var key: DRFFilterKey<V>
    private(set) var comparator: DRFFilterComparator<V>
    private(set) var value: Any?
}


// MARK: - DRFFilterKey & DRFFilterComparator defaults
//
// To define custom keys, DRFFilterKey/DRFFilterComparator should be extended
// the same way as here. Ideally, the struct should be named 'CustomFilterKeys'.
// This funny pattern is used, so a filter can be written like this:
//
// >>> let now: Date = Date()
// >>> _F(.date, .__gte, now)
//
// In order to achieve the same little amount of syntactic sugar, one could
// also dance with associatedtypes in protocols, juggle functions that return
// custom subclasses of the filter components or do some other dark magic
// that would very likely either make the compiler or one's head explode.
// But why would anyone want to do that?
// (Please don't check the git history of this file :D)
//
// By the way, you can submit addition requests to these Defaults via
// a pull request against https://github.com/JanNash/DjangoRFAFInterface.git


// MARK: - DRFFilterKey defaults
enum DefaultFilterKeys: String {
    case date   = "date"
    case id     = "id"
    case name   = "name"
}

public extension DRFFilterKey {
    public static var date: DRFFilterKey<Date>      { return self.init(.date) as! DRFFilterKey<Date> }
    // FIXME: Int should be replaced by Identifier
    public static var id: DRFFilterKey<Int>         { return self.init(.id) as! DRFFilterKey<Int> }
    public static var name: DRFFilterKey<String>    { return self.init(.name) as! DRFFilterKey<String> }
}


// MARK: - DRFFilterComparator defaults
enum DefaultFilterComparators: String {
    case __lt           = "__lt"
    case __lte          = "__lte"
    case __gte          = "__gte"
    case __gt           = "__gt"
    case __in           = "__in"
    case __icontains    = "__icontains"
}


public extension DRFFilterComparator {
    public static var __lt: DRFFilterComparator<Date>           { return self.init(.__lt) as! DRFFilterComparator<Date> }
    public static var __lte: DRFFilterComparator<Date>          { return self.init(.__lte) as! DRFFilterComparator<Date> }
    public static var __gte: DRFFilterComparator<Date>          { return self.init(.__gte) as! DRFFilterComparator<Date> }
    public static var __gt: DRFFilterComparator<Date>           { return self.init(.__gt) as! DRFFilterComparator<Date> }
    public static var __in: DRFFilterComparator<Int>            { return self.init(.__in) as! DRFFilterComparator<Int> }
    public static var __icontains: DRFFilterComparator<String>  { return self.init(.__icontains) as! DRFFilterComparator<String> }
}


// MARK: - DRFFilterKey Struct Declaration
public struct DRFFilterKey<V> {
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
}


// MARK: - DRFFilterComparator Struct Declaration
public struct DRFFilterComparator<V> {
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
}
