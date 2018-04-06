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
            //({ Route.detailPUT($0, "mockdetailputtables") }, MockDetailPuttable.self),
            //({ Route.detailPATCH($0, "mockdetailpatchables") }, MockDetailPatchable.self),
            //({ Route.detailDELETE($0, "mockdetaildeletables") }, MockDetailDeletable.self),
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
        let node: Node = MockNode()
        
        let allRoutesAndObjects = [
            ({ Route.detailGET($0, "mockdetailgettables") }, MockDetailGettable.self),
            //({ Route.detailPUT($0, "mockdetailputtables") }, MockDetailPuttable.self),
            //({ Route.detailPATCH($0, "mockdetailpatchables") }, MockDetailPatchable.self),
            //({ Route.detailDELETE($0, "mockdetaildeletables") }, MockDetailDeletable.self),
        ].map({ routeAndRType in
            (
                routeAndRType.0(routeAndRType.1),
                (0..<1000).map({ routeAndRType.1.init(id: ResourceID("\($0)")) })
            )
        })
        
        (node as! MockNode).routes = allRoutesAndObjects.map({ $0.0 })
        
        func nodeImplementation<T: IdentifiableResource>(_ resource: T, method: ResourceHTTPMethod) -> URL {
            return node.absoluteURL(for: resource, method: method)
        }
        
        func defaultImplementation<T: IdentifiableResource>(_ resource: T, method: ResourceHTTPMethod) -> URL {
            return Dflt.absoluteURL(node: node, for: resource, method: method)
        }
        
        let baseURL: URL = node.baseURL
        
        allRoutesAndObjects.forEach({ routeAndObjects in
            let route: Route = routeAndObjects.0
            let objects = routeAndObjects.1
            let method: ResourceHTTPMethod = route.method
            let listURL: URL = baseURL + route.relativeURL
            
            objects.forEach({ object in
                let expectedURL: URL = listURL + object.id.string
                [nodeImplementation, defaultImplementation].map({ $0(object, method) }).forEach({
                    XCTAssertEqual($0, expectedURL)
                })
            })
        })

    }
    
    // ResourceID URLs
    func testRoutesAgainstRelativeGETURLForResourceID() {
        let node: Node = MockNode()
        
        let allRoutesAndResourceIDs = [
            ({ Route.detailGET($0, "mockdetailgettables") }, MockDetailGettable.self),
        ].map({ routeAndRType in
            (
                routeAndRType.0(routeAndRType.1),
                (0..<1000).map({ routeAndRType.1.init(id: ResourceID("\($0)")).id })
            )
        })
        
        (node as! MockNode).routes = allRoutesAndResourceIDs.map({ $0.0 })
        
        func nodeImplementation<T: DetailGettable>(_ resourceID: ResourceID<T>) -> URL {
            return node.relativeGETURL(for: resourceID)
        }
        
        func defaultImplementation<T: DetailGettable>(_ resourceID: ResourceID<T>) -> URL {
            return Dflt.relativeGETURL(node: node, for: resourceID)
        }
        
        allRoutesAndResourceIDs.forEach({ routeAndResourceIDs in
            let route: Route = routeAndResourceIDs.0
            let resourceIDs: [ResourceID] = routeAndResourceIDs.1
            let listURL: URL = route.relativeURL
            
            resourceIDs.forEach({ resourceID in
                let expectedURL: URL = listURL + resourceID.string
                [nodeImplementation, defaultImplementation].map({ $0(resourceID) }).forEach({
                    XCTAssertEqual($0, expectedURL)
                })
            })
        })
    }
    
    func testRoutesAgainstAbsoluteGETURLForResourceID() {
        let node: Node = MockNode()
        
        let allRoutesAndResourceIDs = [
            ({ Route.detailGET($0, "mockdetailgettables") }, MockDetailGettable.self),
        ].map({ routeAndRType in
            (
                routeAndRType.0(routeAndRType.1),
                (0..<1000).map({ routeAndRType.1.init(id: ResourceID("\($0)")).id })
            )
        })
        
        (node as! MockNode).routes = allRoutesAndResourceIDs.map({ $0.0 })
        
        func nodeImplementation<T: DetailGettable>(_ resourceID: ResourceID<T>) -> URL {
            return node.absoluteGETURL(for: resourceID)
        }
        
        func defaultImplementation<T: DetailGettable>(_ resourceID: ResourceID<T>) -> URL {
            return Dflt.absoluteGETURL(node: node, for: resourceID)
        }
        
        let baseURL: URL = node.baseURL
        
        allRoutesAndResourceIDs.forEach({ routeAndResourceIDs in
            let route: Route = routeAndResourceIDs.0
            let resourceIDs: [ResourceID] = routeAndResourceIDs.1
            let listURL: URL = baseURL + route.relativeURL
            
            resourceIDs.forEach({ resourceID in
                let expectedURL: URL = listURL + resourceID.string
                [nodeImplementation, defaultImplementation].map({ $0(resourceID) }).forEach({
                    XCTAssertEqual($0, expectedURL)
                })
            })
        })
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
        
        func nodeImplementation<T: ListGettable>(_ resourceType: T.Type, _ json: JSON) -> (Pagination, [T]) {
            return node.extractGETListResponse(for: resourceType, from: json)
        }
        
        func defaultImplementation<T: ListGettable>(_ resourceType: T.Type, _ json: JSON) -> (Pagination, [T]) {
            return Dflt.extractGETListResponse(node: node, for: resourceType, from: json)
        }
        
        typealias FixtureType = MockListGettable
        typealias ListResponseKeys = Dflt.ListResponseKeys
        typealias PaginationKeys = DefaultPagination.Keys
        
        let expectedLimit: UInt = 100
        let expectedNext: URL = URL(string: "url/to/next/page")!
        let expectedOffset: UInt = 10
        let expectedPrevious: URL = URL(string: "url/to/previous/page")!
        let expectedTotalCount: UInt = 1000
        let expectedResults: [FixtureType] = (0..<100).map({ FixtureType(name: "\($0)") })
        
        
        let jsonFixture: JSON = JSON([
            ListResponseKeys.meta: [
                PaginationKeys.limit: expectedLimit,
                PaginationKeys.next: expectedNext.absoluteString,
                PaginationKeys.offset: expectedOffset,
                PaginationKeys.previous: expectedPrevious.absoluteString,
                PaginationKeys.totalCount: expectedTotalCount,
            ],
            ListResponseKeys.results: expectedResults.map({ [FixtureType.Keys.name : $0.name] })
        ])
        
        [nodeImplementation, defaultImplementation].map({ $0(FixtureType.self, jsonFixture) }).forEach({ listResponse in
            let (pagination, results): (Pagination, [FixtureType]) = listResponse
            
            XCTAssertEqual(pagination.limit, expectedLimit)
            XCTAssertEqual(pagination.next, expectedNext)
            XCTAssertEqual(pagination.offset, expectedOffset)
            XCTAssertEqual(pagination.previous, expectedPrevious)
            XCTAssertEqual(pagination.totalCount, expectedTotalCount)
            
            XCTAssertEqual(results, expectedResults)
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
