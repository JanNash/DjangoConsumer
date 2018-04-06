//
//  NodeTests.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 11.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import Alamofire
import SwiftyJSON
import DjangoConsumer


// MARK: // Internal
class NodeTests: BaseTest {
    typealias Dflt = DefaultImplementations._Node_
    
    // Routes
    func testNoRouteFoundFatalError() {
        let node: Node = MockNode()
        typealias FixtureType = MockListGettable
        let routeType: RouteType = .list
        let method: ResourceHTTPMethod = .get
        
        (node as! MockNode).routes = []
        
        let expectedMessage: String =
            "[DjangoConsumer.Node] No Route registered in '\(node)' for type " +
            "'\(FixtureType.self)', routeType '\(routeType.rawValue)', method: '\(method)'"
        
        let nodeImplementation: () -> Void = {
            let _: URL = node.relativeURL(for: FixtureType.self, routeType: routeType, method: method)
        }
        
        let defaultImplementation: () -> Void = {
            let _: URL = Dflt.relativeURL(node: node, for: FixtureType.self, routeType: routeType, method: method)
        }
        
        [nodeImplementation, defaultImplementation].forEach({
            self.expect(.fatalError, expectedMessage: expectedMessage, timeout: 5, $0)
        })
    }
    
    func testMultipleRoutesFoundFatalError() {
        let node: Node = MockNode()
        typealias FixtureType = MockListGettable
        let routeType: RouteType = .list
        let method: ResourceHTTPMethod = .get
        
        (node as! MockNode).routes = [
            .listGET(FixtureType.self, "a"),
            .listGET(FixtureType.self, "b")
        ]
        
        let expectedMessage: String =
            "[DjangoConsumer.Node] Multiple Routes registered in '\(node)' for type " +
            "'\(FixtureType.self)', routeType '\(routeType.rawValue)', method: '\(method)'"
        
        let nodeImplementation: () -> Void = {
            let _: URL = node.relativeURL(for: FixtureType.self, routeType: routeType, method: method)
        }
        
        let defaultImplementation: () -> Void = {
            let _: URL = Dflt.relativeURL(node: node, for: FixtureType.self, routeType: routeType, method: method)
        }
        
        [nodeImplementation, defaultImplementation].forEach({
            self.expect(.fatalError, expectedMessage: expectedMessage, timeout: 5, $0)
        })
    }
    
    // List GET Request Helpers
    func testDefaultFilters() {
        let node: Node = MockNode()
        typealias FixtureType = MockFilteredListGettable
        
        let nodeImplementation: () -> [FilterType] = {
            node.defaultFilters(for: FixtureType.self)
        }
        
        let defaultImplementation: () -> [FilterType] = {
            Dflt.defaultFilters(node: node, for: FixtureType.self)
        }
        
        [nodeImplementation, defaultImplementation].map({ $0() }).forEach({
            XCTAssert($0.isEmpty)
        })
    }
    
    func testPaginationType() {
        let node: Node = MockNode()
        typealias FixtureType = MockListGettable
        
        let nodeImplementation: () -> Pagination.Type = {
            node.paginationType(for: FixtureType.self)
        }
        
        let defaultImplementation: () -> Pagination.Type = {
            Dflt.paginationType(node: node, for: FixtureType.self)
        }
        
        [nodeImplementation, defaultImplementation].map({ $0() }).forEach({
            XCTAssert($0 == DefaultPagination.self)
        })
    }
    
    // Parameter Generation
    func testParametersFromFilters() {
        let node: Node = MockNode()
        let nameFilter: _F<String> = _F(.name, .__icontains, "blubb")
        let filters = [nameFilter]
        
        let nodeImplementation: () -> Parameters = {
            node.parametersFrom(filters: filters)
        }
        
        let defaultImplementation: () -> Parameters = {
            DefaultImplementations._Node_.parametersFrom(node: node, filters: filters)
        }
        
        [nodeImplementation, defaultImplementation].map({ $0() }).forEach({
            XCTAssert($0.count == 1)
            XCTAssertEqual($0[nameFilter.stringKey] as? String, nameFilter.value as? String)
        })
    }
    
    func testParametersFromOffsetAndLimit() {
        let node: Node = MockNode()
        let expectedOffset: UInt = 10
        let expectedLimit: UInt = 100
        
        let nodeImplementation: () -> Parameters = {
            node.parametersFrom(offset: expectedOffset, limit: expectedLimit)
        }
        
        let defaultImplementation: () -> Parameters = {
            Dflt.parametersFrom(node: node, offset: expectedOffset, limit: expectedLimit)
        }
        
        [nodeImplementation, defaultImplementation].map({ $0() }).forEach({
            XCTAssert($0.count == 2)
            XCTAssertEqual($0[DefaultPagination.Keys.offset] as? UInt, expectedOffset)
            XCTAssertEqual($0[DefaultPagination.Keys.limit] as? UInt, expectedLimit)
        })
    }
    
    func testParametersFromOffsetAndLimitAndFilters() {
        let node: Node = MockNode()
        let expectedOffset: UInt = 10
        let expectedLimit: UInt = 100
        let nameFilter: _F<String> = _F(.name, .__icontains, "blubb")
        let filters = [nameFilter]
        
        let nodeImplementation: () -> Parameters = {
            node.parametersFrom(offset: expectedOffset, limit: expectedLimit, filters: filters)
        }
        
        let defaultImplementation: () -> Parameters = {
            Dflt.parametersFrom(node: node, offset: expectedOffset, limit: expectedLimit, filters: filters)
        }
        
        [nodeImplementation, defaultImplementation].map({ $0() }).forEach({
            XCTAssert($0.count == 3)
            XCTAssertEqual($0[DefaultPagination.Keys.offset] as? UInt, expectedOffset)
            XCTAssertEqual($0[DefaultPagination.Keys.limit] as? UInt, expectedLimit)
            XCTAssertEqual($0[nameFilter.stringKey] as? String, nameFilter.value as? String)
        })
    }
    
    func testParametersFromParameterConvertible() {
        let node: Node = MockNode()
        let object: ParameterConvertible = MockListPostable(name: "Blubb")
        let expectedParameters: [String : String] = object.toParameters() as! [String : String]
        
        let nodeImplementation: (ResourceHTTPMethod) -> [String : String] = {
            node.parametersFrom(object: object, method: $0) as! [String : String]
        }
        
        let defaultImplementation: (ResourceHTTPMethod) -> [String : String] = {
            Dflt.parametersFrom(node: node, object: object, method: $0) as! [String : String]
        }
        
        ResourceHTTPMethod.all.forEach({ method in
            [nodeImplementation, defaultImplementation].map({ $0(method) }).forEach({
                XCTAssertEqual($0, expectedParameters)
            })
        })
    }
    
    func testParametersFromListPostables() {
        
    }
    
    // URLs
    // MetaResource.Type URLs
    func testRoutesAgainstRelativeURLForResourceType() {
        let mockNode: MockNode = MockNode()
        let node: Node = mockNode
        
        let routes: [Route] = [
            .listGET(MockListGettable.self, "mocklistgettables"),
            .listGET(MockFilteredListGettable.self, "mockfilteredlistgettables"),
            .detailGET(MockDetailGettable.self, "mockdetailgettables"),
            //.listPOST(MockListPostable.self, "mocklistpostables"),
            .singlePOST(MockSinglePostable.self, "mocksinglepostables"),
            //.detailPUT(MockDetailPostable.self, "mockdetailputtables"),
            //.detailPATCH(MockDetailPatchable.self, "mockdetailpatchables"),
            //.detailDELETE(MockDetailDeletable.self, "mockdetaildeletables")
        ]
        
        mockNode.routes = routes
        
        let nodeImplementation: (Route) -> URL = {
            node.relativeURL(for: $0.resourceType, routeType: $0.routeType, method: $0.method)
        }
        
        let defaultImplementation: (Route) -> URL = {
            Dflt.relativeURL(node: node, for: $0.resourceType, routeType: $0.routeType, method: $0.method)
        }
        
        routes.forEach({ route in
            let expectedURL: URL = route.relativeURL
            [nodeImplementation, defaultImplementation].map({ $0(route) }).forEach({
                XCTAssertEqual($0, expectedURL)
            })
        })
    }
    
    func testRoutesAgainstAbsoluteURLForResourceType() {
        let mockNode: MockNode = MockNode()
        let node: Node = mockNode
        
        let routes: [Route] = [
            .listGET(MockListGettable.self, "mocklistgettables"),
            .listGET(MockFilteredListGettable.self, "mockfilteredlistgettables"),
            .detailGET(MockDetailGettable.self, "mockdetailgettables"),
            //.listPOST(MockListPostable.self, "mocklistpostables"),
            .singlePOST(MockSinglePostable.self, "mocksinglepostables"),
            //.detailPUT(MockDetailPostable.self, "mockdetailputtables"),
            //.detailPATCH(MockDetailPatchable.self, "mockdetailpatchables"),
            //.detailDELETE(MockDetailDeletable.self, "mockdetaildeletables")
        ]
        
        mockNode.routes = routes
        
        let nodeImplementation: (Route) -> URL = {
            node.absoluteURL(for: $0.resourceType, routeType: $0.routeType, method: $0.method)
        }
        
        let defaultImplementation: (Route) -> URL = {
            Dflt.absoluteURL(node: node, for: $0.resourceType, routeType: $0.routeType, method: $0.method)
        }
        
        let baseURL: URL = node.baseURL
        
        routes.forEach({ route in
            let expectedURL: URL = baseURL + route.relativeURL
            [nodeImplementation, defaultImplementation].map({ $0(route) }).forEach({
                XCTAssertEqual($0, expectedURL)
            })
        })
    }

    // IdentifiableResource URLs
    func testRoutesAgainstRelativeURLForIdentifiableResource() {
        let node: Node = MockNode()
        
        let allRoutesAndObjects = [
            ({ Route.detailGET($0, "mockdetailgettables") }, MockDetailGettable.self),
//            ({ Route.detailPUT($0, "mockdetailputtables") }, MockDetailPuttable.self),
//            ({ Route.detailPATCH($0, "mockdetailpatchables") }, MockDetailPatchable.self),
//            ({ Route.detailDELETE($0, "mockdetaildeletables") }, MockDetailDeletable.self),
        ].map({ routeAndRType in
            (
                routeAndRType.0(routeAndRType.1),
                (0..<1000).map({ routeAndRType.1.init(id: ResourceID("\($0)")) })
            )
        })
        
        (node as! MockNode).routes = allRoutesAndObjects.map({ $0.0 })
        
        func nodeImplementation<T: IdentifiableResource>(_ resource: T, method: ResourceHTTPMethod) -> URL {
            return node.relativeURL(for: resource, method: method)
        }
        
        func defaultImplementation<T: IdentifiableResource>(_ resource: T, method: ResourceHTTPMethod) -> URL {
            return Dflt.relativeURL(node: node, for: resource, method: method)
        }
        
        allRoutesAndObjects.forEach({ routeAndObjects in
            let route: Route = routeAndObjects.0
            let objects = routeAndObjects.1
            let method: ResourceHTTPMethod = route.method
            let listURL: URL = route.relativeURL
            
            objects.forEach({ object in
                let expectedURL: URL = listURL + object.id.string
                [nodeImplementation, defaultImplementation].map({ $0(object, method) }).forEach({
                    XCTAssertEqual($0, expectedURL)
                })
            })
        })
    }
    
    func testRoutesAgainstAbsoluteURLForIdentifiableResource() {
        // Setup
        let node: Node = MockNode()
        
        let detailGettableRoute: Route = .detailGET(MockDetailGettable.self, "mockdetailgettables")
//        let detailPuttableRoute: Route = .detailPUT(MockDetailPuttable.self, "mockdetailputtables")
//        let detailPatchableRoute: Route = .detailPATCH(MockDetailPatchable.self, "mockdetailpatchables")
//        let detailDeletableRoute: Route = .detailDELETE(MockDetailDeletable.self, "mockdetaildeletables")
        
        (node as! MockNode).routes = [
            detailGettableRoute,
//            detailPuttableRoute,
//            detailPatchableRoute,
//            detailDeletableRoute
        ]
        
        // Test Helper
        let baseURL: URL = node.baseURL
        func objectsMethodsAndExpectedURLs<T: IdentifiableResource>(expectedRoute: Route, objects: [T]) -> [(T, ResourceHTTPMethod, URL)] {
            return objects.map({ ($0, expectedRoute.method, baseURL + expectedRoute.relativeURL + $0.id.string) })
        }
        
        // Test Function
        func testAbsoluteURL<T: IdentifiableResource>(_ resource: T, _ method: ResourceHTTPMethod, _ expectedURL: URL) {
            XCTAssertEqual(node.absoluteURL(for: resource, method: method), expectedURL)
            XCTAssertEqual(DefaultImplementations._Node_.absoluteURL(node: node, for: resource, method: method), expectedURL)
        }
        
        // Fixtures
        let detailGettables: [MockDetailGettable] = (0..<1000).map({ MockDetailGettable(id: ResourceID("\($0)")) })
//        let detailPuttables: [MockDetailPuttable] = (0..<1000).map({ MockDetailPuttable(id: ResourceID("\($0)")) })
//        let detailPatchables: [MockDetailPatchable] = (0..<1000).map({ MockDetailPatchable(id: ResourceID("\($0)")) })
//        let detailDeletables: [MockDetailDeletable] = (0..<1000).map({ MockDetailDeletable(id: ResourceID("\($0)")) })
        
        // Test Run
        [
            (detailGettableRoute, detailGettables),
//            (detailPuttableRoute, detailPuttables),
//            (detailPatchableRoute, detailPatchables),
//            (detailDeletableRoute, detailDeletables),
        ]
        .map(objectsMethodsAndExpectedURLs)
        .reduce([], +)
        .forEach(testAbsoluteURL)
    }
    
    // ResourceID URLs
    func testRoutesAgainstRelativeGETURLForResourceID() {
        // Setup
        let node: Node = MockNode()
        
        let detailGettableRoute: Route = .detailGET(MockDetailGettable.self, "mockdetailgettables")
        
        (node as! MockNode).routes = [detailGettableRoute]
        
        // Test Helper
        func resourceIDsAndExpectedURLs<T: DetailGettable>(expectedRoute: Route, resourceIDs: [ResourceID<T>]) -> [(ResourceID<T>, URL)] {
            return resourceIDs.map({ ($0, expectedRoute.relativeURL + $0.string) })
        }
        
        // Test Function
        func testRelativeGETURL<T: DetailGettable>(_ resourceID: ResourceID<T>, _ expectedURL: URL) {
            XCTAssertEqual(node.relativeGETURL(for: resourceID), expectedURL)
            XCTAssertEqual(DefaultImplementations._Node_.relativeGETURL(node: node, for: resourceID), expectedURL)
        }
        
        // Fixtures
        let detailGettableIDs: [ResourceID<MockDetailGettable>] = (0..<1000).map({ ResourceID("\($0)") })
        
        // Test Run
        [
            (detailGettableRoute, detailGettableIDs),
        ]
        .map(resourceIDsAndExpectedURLs)
        .reduce([], +)
        .forEach(testRelativeGETURL)
    }
    
    func testRoutesAgainstAbsoluteGETURLForResourceID() {
        // Setup
        let node: Node = MockNode()
        
        let detailGettableRoute: Route = .detailGET(MockDetailGettable.self, "mockdetailgettables")
        
        (node as! MockNode).routes = [detailGettableRoute]
        
        // Test Helper
        let baseURL: URL = node.baseURL
        func resourceIDsAndExpectedURLs<T: DetailGettable>(expectedRoute: Route, resourceIDs: [ResourceID<T>]) -> [(ResourceID<T>, URL)] {
            return resourceIDs.map({ ($0, baseURL + expectedRoute.relativeURL + $0.string) })
        }
        
        // Test Function
        func testAbsoluteGETURL<T: DetailGettable>(_ resourceID: ResourceID<T>, _ expectedURL: URL) {
            XCTAssertEqual(node.absoluteGETURL(for: resourceID), expectedURL)
            XCTAssertEqual(DefaultImplementations._Node_.absoluteGETURL(node: node, for: resourceID), expectedURL)
        }
        
        // Fixtures
        let detailGettableIDs: [ResourceID<MockDetailGettable>] = (0..<1000).map({ ResourceID("\($0)") })
        
        // Test Run
        [
            (detailGettableRoute, detailGettableIDs),
        ]
        .map(resourceIDsAndExpectedURLs)
        .reduce([], +)
        .forEach(testAbsoluteGETURL)
    }
    
    // Response Extraction
    // Detail Response Extraction Helpers
    func testExtractSingleObject() {
        
    }
    
    // List Response Extraction Helpers
    func testExtractGETListResponsePagination() {
        
    }
    
    func testExtractGETListResponseObjects() {
        
    }
    
    func testExtractGETListResponse() {
        let node: Node = MockNode()
        typealias FixtureType = MockListGettable
        
        func nodeImplementation(_ json: JSON) -> (Pagination, [FixtureType]) {
            return node.extractGETListResponse(for: FixtureType.self, from: json)
        }
        
        func defaultImplementation(_ json: JSON) -> (Pagination, [FixtureType]) {
            return DefaultImplementations._Node_.extractGETListResponse(node: node, for: FixtureType.self, from: json)
        }
        
        let expectedLimit: UInt = 100
        let expectedNext: URL = URL(string: "url/to/next/page")!
        let expectedOffset: UInt = 10
        let expectedPrevious: URL = URL(string: "url/to/previous/page")!
        let expectedTotalCount: UInt = 1000
        let expectedResults: [FixtureType] = (0..<100).map({ FixtureType(id: "\($0)") })
        
        let jsonFixture: JSON = JSON([
            DefaultImplementations._Node_.ListResponseKeys.meta: [
                DefaultPagination.Keys.limit: expectedLimit,
                DefaultPagination.Keys.next: expectedNext.absoluteString,
                DefaultPagination.Keys.offset: expectedOffset,
                DefaultPagination.Keys.previous: expectedPrevious.absoluteString,
                DefaultPagination.Keys.totalCount: expectedTotalCount,
            ],
            DefaultImplementations._Node_.ListResponseKeys.results: expectedResults.map({ [FixtureType.Keys.id : $0.id] })
        ])
        
        [nodeImplementation(jsonFixture), defaultImplementation(jsonFixture)].forEach({ listResponse in
            let (pagination, results): (Pagination, [FixtureType]) = listResponse
            
            XCTAssertEqual(pagination.limit, expectedLimit)
            XCTAssertEqual(pagination.next, expectedNext)
            XCTAssertEqual(pagination.offset, expectedOffset)
            XCTAssertEqual(pagination.previous, expectedPrevious)
            XCTAssertEqual(pagination.totalCount, expectedTotalCount)
            
            XCTAssertEqual(results.count, expectedResults.count)
            XCTAssertEqual(results.map({ $0.id }), expectedResults.map({ $0.id }))
        })
    }
    
    func testExtractPOSTListResponse() {
        let node: Node = MockNode()
        typealias FixtureType = MockListPostable
        
        func nodeImplementation(_ json: JSON) -> [FixtureType] {
            return node.extractPOSTListResponse(for: FixtureType.self, from: json)
        }
        
        func defaultImplementation(_ json: JSON) -> [FixtureType] {
            return DefaultImplementations._Node_.extractPOSTListResponse(node: node, for: FixtureType.self, from: json)
        }
        
        let expectedResults: [FixtureType] = (0..<100).map({ FixtureType(name: "\($0)") })
        
        let jsonFixture: JSON = JSON([
            DefaultImplementations._Node_.ListResponseKeys.results: expectedResults.map({ [FixtureType.Keys.name : $0.name] })
        ])
        
        [nodeImplementation(jsonFixture), defaultImplementation(jsonFixture)].forEach({ results in
            XCTAssertEqual(results.count, expectedResults.count)
            XCTAssertEqual(results.map({ $0.name }), expectedResults.map({ $0.name }))
        })
    }
}
