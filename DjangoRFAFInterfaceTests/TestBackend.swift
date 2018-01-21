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
}


// MARK: // Private
// MARK: Override Implementations
private extension TestBackend {
    func _filterClosure<T: DRFListGettable>(for queryParameters: Parameters, with objectType: T.Type) -> ((T) -> Bool) {
        return { _ in true }
    }
    
    func _fixtures<T: DRFListGettable>(for objectType: T.Type) -> [T] {
        return []
    }
    
    func _createJSONDict<T: DRFListGettable>(from object: T) -> [String : Any] {
        return [:]
    }
}


// MARK: Add Routes
private extension TestBackend {
    func _addRoutes() {
        self.addRoute((URL(string: "foos")!, self.createPaginatedListResponse(for: Foo.self)))
    }
}
