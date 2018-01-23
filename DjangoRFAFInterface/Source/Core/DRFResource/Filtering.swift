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
    public static var __lt: DRFFilterComparator<__lt_Type>                { return _C<__lt_Type>(.__lt) }
    public static var __lte: DRFFilterComparator<__lte_Type>              { return _C<__lte_Type>(.__lte) }
    public static var __gte: DRFFilterComparator<__gte_Type>              { return _C<__gte_Type>(.__gte) }
    public static var __gt: DRFFilterComparator<__gt_Type>                { return _C<__gt_Type>(.__gt) }
    public static var __in: DRFFilterComparator<__in_Type>                { return _C<__in_Type>(.__in) }
    public static var __icontains: DRFFilterComparator<__icontains_Type>  { return _C<__icontains_Type>(.__icontains) }
    
    // Helpers
    // The class name is simply too long...
    private typealias _C<V> = DRFFilterComparator<V>
    
    enum DefaultFilterComparators: String {
        case __lt           = "__lt"
        case __lte          = "__lte"
        case __gte          = "__gte"
        case __gt           = "__gt"
        case __in           = "__in"
        case __icontains    = "__icontains"
    }
}


// MARK: - DRFFilterComparator Special Types
public protocol __lt_Type {}
extension Date: __lt_Type {}
extension Int: __lt_Type {}
extension UInt: __lt_Type {}
extension Double: __lt_Type {}

public protocol __lte_Type {}
extension Date: __lte_Type {}
extension Int: __lte_Type {}
extension UInt: __lte_Type {}
extension Double: __lte_Type {}

public protocol __gte_Type {}
extension Date: __gte_Type {}
extension Int: __gte_Type {}
extension UInt: __gte_Type {}
extension Double: __gte_Type {}

public protocol __gt_Type {}
extension Date: __gt_Type {}
extension Int: __gt_Type {}
extension UInt: __gt_Type {}
extension Double: __gt_Type {}

public protocol __in_Type {}

public protocol __icontains_Type {}

// // // The pattern ends // // //


// MARK: - DRFFilter Struct Declaration
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
