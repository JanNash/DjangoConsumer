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
        self.addRoute((.GET_list_mockListGettables, self.filteredPaginatedListResponse))
        self.addRoute((.GET_list_mockFilteredListGettables, self.filteredPaginatedListResponse))
    }
    
    // // MARK: Overrides
    // List GET
    override func filterClosure(for queryParameters: Parameters, with routePattern: String) -> FilterClosure {
        // TODO: Implement the filter closures.
        // Without having access to the concrete type of the objects that are going to be
        // filtered, that's not going to be too easy. Maybe it's possible to add a function
        // that returns a concrete object type for a route pattern and switch these three
        // functions back to taking in a type instead of a routePattern?
        return self._filterClosure(for: queryParameters, with: RoutePattern(routePattern))
    }
    
    // General
    override func fixtures(for routePattern: String) -> [DRFListGettable] {
        return self._fixtures(for: RoutePattern(routePattern))
    }
    
    override func createJSONDict(from object: DRFListGettable, for routePattern: String) -> [String : Any] {
        return self._createJSONDict(from: object, for: RoutePattern(routePattern))
    }
    
    // // MARK: Overloads
    // Add Route
    func addRoute(_ route: (routePattern: RoutePattern, response: Response)) {
        self.addRoute((route.routePattern.rawValue, route.response))
    }
    
    // List GET
    func filterClosure(for queryParameters: Parameters, with routePattern: RoutePattern) -> FilterClosure {
        return self._filterClosure(for: queryParameters, with: routePattern)
    }
    
    // General
    func fixtures(for routePattern: RoutePattern) -> [DRFListGettable] {
        return self._fixtures(for: routePattern)
    }
    
    func createJSONDict(from object: DRFListGettable, for routePattern: RoutePattern) -> [String : Any] {
        return self._createJSONDict(from: object, for: routePattern)
    }
    
    // // MARK: Constants
    // Routes
    // This enum can't be implemented in MockBackend, since it isn't possible
    // to add cases in extensions, so it wouldn't make any sense.
    // Still, it is recommendable to use an enum because it guarantees pattern uniqueness.
    enum RoutePattern: String {
        case GET_list_mockListGettables          = "^/listgettables/$"
        case GET_list_mockFilteredListGettables  = "^/filteredlistgettables/$"
        
        init(_ string: String) {
            guard let routePattern: RoutePattern = RoutePattern(rawValue: string) else {
                fatalError("[TestBackend] No RoutePattern registered for '\(string)'")
            }
            self = routePattern
        }
    }
    
    // // MARK: Fixtures
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
    func _filterClosure(for queryParameters: Parameters, with routePattern: RoutePattern) -> FilterClosure {
        switch routePattern {
        case .GET_list_mockListGettables:           return { _ in return true }
        case .GET_list_mockFilteredListGettables:   return { _ in return true }
        }
    }
    
    func _fixtures(for routePattern: RoutePattern) -> [DRFListGettable] {
        switch routePattern {
        case .GET_list_mockListGettables:         return self.mockListGettables
        case .GET_list_mockFilteredListGettables: return self.mockFilteredListGettables
        }
    }
    
    // General
    func _createJSONDict(from object: DRFListGettable, for routePattern: RoutePattern) -> [String : Any] {
        // TODO: Once DRFPostable is implemented, this implementation can likely be simplified.
        switch routePattern {
        case .GET_list_mockListGettables:
            let listGettable: MockListGettable = object as! MockListGettable
            return [
                MockListGettable.Keys.id : listGettable.id,
            ]
        case .GET_list_mockFilteredListGettables:
            let filteredListGettable: MockFilteredListGettable = object as! MockFilteredListGettable
            return [
                MockFilteredListGettable.Keys.id : filteredListGettable.id,
                MockFilteredListGettable.Keys.date : filteredListGettable.date.iso8601(),
                MockFilteredListGettable.Keys.name : filteredListGettable.name,
            ]
        }
    }
}
