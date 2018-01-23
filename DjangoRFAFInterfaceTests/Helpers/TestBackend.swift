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
    // List GET
    override func filterClosure<T: DRFListGettable>(for queryParameters: Parameters, with objectType: T.Type) -> ((T) -> Bool) {
        return self._filterClosure(for: queryParameters, with: objectType)
    }
    
    // General
    override func fixtures<T: DRFListGettable>(for objectType: T.Type) -> [T] {
        return self._fixtures(for: objectType)
    }
    
    override func createJSONDict<T: DRFListGettable>(from object: T) -> [String : Any] {
        return self._createJSONDict(from: object)
    }
    
    
    // Constants
    // Fixtures
    let mockListGettables: [MockListGettable] = [
        MockListGettable(id: "1"),
        MockListGettable(id: "2"),
        MockListGettable(id: "3"),
        MockListGettable(id: "4"),
        MockListGettable(id: "5"),
        MockListGettable(id: "6"),
    ]
}


// MARK: // Private
// MARK: Override Implementations
private extension TestBackend {
    // List GET
    func _filterClosure<T: DRFListGettable>(for queryParameters: Parameters, with objectType: T.Type) -> ((T) -> Bool) {
        return { _ in true }
    }
    
    func _fixtures<T: DRFListGettable>(for objectType: T.Type) -> [T] {
        if objectType == MockListGettable.self { return self.mockListGettables as! [T] }
        return []
    }
    
    // General
    func _createJSONDict<T: DRFListGettable>(from object: T) -> [String : Any] {
        if let testListGettable: MockListGettable = object as? MockListGettable {
            return [
                MockListGettable.Keys.id : testListGettable.id,
            ]
        }
        return [:]
    }
}


// MARK: Add Routes
private extension TestBackend {
    func _addRoutes() {
        self.addRoute((URL(string: "listgettables")!, self.createPaginatedListResponse(for: MockListGettable.self)))
    }
}
