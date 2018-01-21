//
//  TestBackend.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 21.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire
import DjangoRFAFInterface


// MARK: // Internal
class TestBackend: MockBackend {
    // Init
    override init() {
        super.init()
        self._addRoutes()
    }
    
    // Overrides
    override func filterClosure<T: DRFListGettable>(for queryParameters: Parameters, with objectType: T.Type) -> ((T) -> Bool) {
        return self._filterClosure(for: queryParameters, with: objectType)
    }
    
    override func fixtures<T: DRFListGettable>(for objectType: T.Type) -> [T] {
        return self._fixtures(for: objectType)
    }
    
    override func createJSONDict<T: DRFListGettable>(from object: T) -> [String : Any] {
        return self._createJSONDict(from: object)
    }
    
    
    // Private Variables
    private var _fooFixtures: [Foo] = [
        Foo(id: "1", bar: "A"),
        Foo(id: "2", bar: "B"),
        Foo(id: "3", bar: "C"),
        Foo(id: "4", bar: "D"),
        Foo(id: "5", bar: "E"),
        Foo(id: "6", bar: "F"),
    ]
}


// MARK: // Private
// MARK: Override Implementations
private extension TestBackend {
    func _filterClosure<T: DRFListGettable>(for queryParameters: Parameters, with objectType: T.Type) -> ((T) -> Bool) {
        return { _ in true }
    }
    
    func _fixtures<T: DRFListGettable>(for objectType: T.Type) -> [T] {
        if objectType == Foo.self {
            return self._fooFixtures as! [T]
        }
        return []
    }
    
    func _createJSONDict<T: DRFListGettable>(from object: T) -> [String : Any] {
        if let foo: Foo = object as? Foo {
            return [
                Foo.Keys.id : foo.id,
                Foo.Keys.bar : foo.bar
            ]
        }
        return [:]
    }
}


// MARK: Add Routes
private extension TestBackend {
    func _addRoutes() {
        self.addRoute((URL(string: "foos")!, self.createPaginatedListResponse(for: Foo.self)))
    }
}
