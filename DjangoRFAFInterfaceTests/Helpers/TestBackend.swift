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
    
    
    // Private Variables
    // Fixtures
    private var _testListGettables: [TestListGettable] = [
        TestListGettable(id: "1"),
        TestListGettable(id: "2"),
        TestListGettable(id: "3"),
        TestListGettable(id: "4"),
        TestListGettable(id: "5"),
        TestListGettable(id: "6"),
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
        if objectType == TestListGettable.self { return self._testListGettables as! [T] }
        return []
    }
    
    // General
    func _createJSONDict<T: DRFListGettable>(from object: T) -> [String : Any] {
        if let testListGettable: TestListGettable = object as? TestListGettable {
            return [
                TestListGettable.Keys.id : testListGettable.id,
            ]
        }
        return [:]
    }
}


// MARK: Add Routes
private extension TestBackend {
    func _addRoutes() {
        self.addRoute((URL(string: "listgettables")!, self.createPaginatedListResponse(for: TestListGettable.self)))
    }
}
