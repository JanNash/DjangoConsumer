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
    
    let mockFilteredListGettables: [MockFilteredListGettable] = [
        MockFilteredListGettable(id: "1", date: Date().startOfDay.add(components: 3.days), name: "A"),
        MockFilteredListGettable(id: "2", date: Date().startOfDay.add(components: 2.days), name: "B"),
        MockFilteredListGettable(id: "3", date: Date().startOfDay.add(components: 1.day), name: "C"),
        MockFilteredListGettable(id: "4", date: Date().startOfDay, name: "D"),
        MockFilteredListGettable(id: "5", date: Date().startOfDay.add(components: 1.day), name: "E"),
        MockFilteredListGettable(id: "6", date: Date().startOfDay.add(components: 2.days), name: "F"),
        MockFilteredListGettable(id: "7", date: Date().startOfDay.add(components: 3.days), name: "G"),
    ]
}


// MARK: // Private
// MARK: Override Implementations
private extension TestBackend {
    // List GET
    func _filterClosure<T: DRFListGettable>(for queryParameters: Parameters, with objectType: T.Type) -> ((T) -> Bool) {
        if objectType == MockListGettable.self {
            return { _ in return true }
        } else if objectType == MockFilteredListGettable.self {
            return { _ in return true }
        }
        fatalError("[TestBackend] No filter closure defined for '\(objectType)'")
    }
    
    func _fixtures<T: DRFListGettable>(for objectType: T.Type) -> [T] {
        if objectType == MockListGettable.self {
            return self.mockListGettables as! [T]
        } else if objectType == MockFilteredListGettable.self {
            return self.mockListGettables as! [T]
        }
        fatalError("[TestBackend] No fixtures defined for '\(objectType)'")
    }
    
    // General
    func _createJSONDict<T: DRFListGettable>(from object: T) -> [String : Any] {
        if let listGettable: MockListGettable = object as? MockListGettable {
            return [
                MockListGettable.Keys.id : listGettable.id,
            ]
        } else if let filteredListGettable: MockFilteredListGettable = object as? MockFilteredListGettable {
            return [
                MockFilteredListGettable.Keys.id : filteredListGettable.id,
                MockFilteredListGettable.Keys.date : filteredListGettable.date,
                MockFilteredListGettable.Keys.name : filteredListGettable.name,
            ]
        }
        fatalError("[TestBackend] No mapping defined for '\(object)'")
    }
}


// MARK: Add Routes
private extension TestBackend {
    func _addRoutes() {
        self.addRoute((URL(string: "listgettables")!, self.createPaginatedListResponse(for: MockListGettable.self)))
        self.addRoute((URL(string: "filteredlistgettables")!, self.createPaginatedListResponse(for: MockFilteredListGettable.self)))
    }
}
