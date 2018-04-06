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
    typealias PaginationKeys = DefaultPagination.Keys
    typealias ListRequestKeys = Dflt.ListRequestKeys
    typealias ListResponseKeys = Dflt.ListResponseKeys
    
    // Routes
    func testNoRouteFoundFatalError() {
        func nodeImplementation<T: MetaResource>(_ node: Node, _ resourceType: T.Type, _ routeType: RouteType, _ method: ResourceHTTPMethod) -> () -> Void {
            return { let _: URL = node.relativeURL(for: resourceType, routeType: routeType, method: method) }
        }
        
        func defaultImplementation<T: MetaResource>(_ node: Node, _ resourceType: T.Type, _ routeType: RouteType, _ method: ResourceHTTPMethod) -> () -> Void {
            return { let _: URL = Dflt.relativeURL(node: node, for: resourceType, routeType: routeType, method: method) }
        }
        
        let node: Node = MockNode()
        let fixtureType = MockListGettable.self
        let routeType: RouteType = .list
        let method: ResourceHTTPMethod = .get
        
        (node as! MockNode).routes = []
        
        let expectedMessage: String =
            "[DjangoConsumer.Node] No Route registered in '\(node)' for type " +
            "'\(fixtureType)', routeType '\(routeType.rawValue)', method: '\(method)'"
        
        [nodeImplementation, defaultImplementation].map({
            $0(node, fixtureType, routeType, method)
        }).forEach({
            self.expect(.fatalError, expectedMessage: expectedMessage, timeout: 10, $0)
        })
    }
    
    func testMultipleRoutesFoundFatalError() {
        func nodeImplementation<T: MetaResource>(_ node: Node, _ resourceType: T.Type, _ routeType: RouteType, _ method: ResourceHTTPMethod) -> () -> Void {
            return { let _: URL = node.relativeURL(for: resourceType, routeType: routeType, method: method) }
        }
        
        func defaultImplementation<T: MetaResource>(_ node: Node, _ resourceType: T.Type, _ routeType: RouteType, _ method: ResourceHTTPMethod) -> () -> Void {
            return { let _: URL = Dflt.relativeURL(node: node, for: resourceType, routeType: routeType, method: method) }
        }
        
        let node: Node = MockNode()
        let fixtureType = MockListGettable.self
        let routeType: RouteType = .list
        let method: ResourceHTTPMethod = .get
        
        (node as! MockNode).routes = [
            .listGET(fixtureType, "a"),
            .listGET(fixtureType, "b")
        ]
        
        let expectedMessage: String =
            "[DjangoConsumer.Node] Multiple Routes registered in '\(node)' for type " +
            "'\(fixtureType)', routeType '\(routeType.rawValue)', method: '\(method)'"
        
        [nodeImplementation, defaultImplementation].map({
            $0(node, fixtureType, routeType, method)
        }).forEach({
            self.expect(.fatalError, expectedMessage: expectedMessage, timeout: 10, $0)
        })
    }
    
    // List GET Request Helpers
    func testDefaultFilters() {
        func nodeImplementation<T: FilteredListGettable>(_ node: Node, _ resourceType: T.Type) -> [FilterType] {
            return node.defaultFilters(for: resourceType)
        }
        
        func defaultImplementation<T: FilteredListGettable>(_ node: Node, _ resourceType: T.Type) -> [FilterType] {
            return Dflt.defaultFilters(node: node, for: resourceType)
        }
        
        let node: Node = MockNode()
        let fixtureType = MockFilteredListGettable.self
        
        [nodeImplementation, defaultImplementation].map({
            $0(node, fixtureType)
        }).forEach({
            XCTAssert($0.isEmpty)
        })
    }
    
    func testPaginationType() {
        func nodeImplementation<T: ListGettable>(_ node: Node, _ resourceType: T.Type) -> Pagination.Type {
            return node.paginationType(for: resourceType)
        }
        
        func defaultImplementation<T: ListGettable>(_ node: Node, _ resourceType: T.Type) -> Pagination.Type {
            return Dflt.paginationType(node: node, for: resourceType)
        }
        
        let node: Node = MockNode()
        let fixtureType = MockListGettable.self
        
        [nodeImplementation, defaultImplementation].map({
            $0(node, fixtureType)
        }).forEach({
            XCTAssert($0 == DefaultPagination.self)
        })
    }
    
    // Parameter Generation
    func testParametersFromFilters() {
        func nodeImplementation(_ node: Node, _ filters: [FilterType]) -> Parameters {
            return node.parametersFrom(filters: filters)
        }
        
        func defaultImplementation(_ node: Node, _ filters: [FilterType]) -> Parameters {
            return Dflt.parametersFrom(node: node, filters: filters)
        }
        
        let node: Node = MockNode()
        let nameFilter: _F<String> = _F(.name, .__icontains, "blubb")
        let filters = [nameFilter]
        
        [nodeImplementation, defaultImplementation].map({
            $0(node, filters)
        }).forEach({
            XCTAssert($0.count == 1)
            XCTAssertEqual($0[nameFilter.stringKey] as? String, nameFilter.value as? String)
        })
    }
    
    func testParametersFromOffsetAndLimit() {
        func nodeImplementation(_ node: Node, _ offset: UInt, _ limit: UInt) -> Parameters {
            return node.parametersFrom(offset: offset, limit: limit)
        }
        
        func defaultImplementation(_ node: Node, _ offset: UInt, _ limit: UInt) -> Parameters {
            return Dflt.parametersFrom(node: node, offset: offset, limit: limit)
        }
        
        let node: Node = MockNode()
        let expectedOffset: UInt = 10
        let expectedLimit: UInt = 100
        
        [nodeImplementation, defaultImplementation].map({
            $0(node, expectedOffset, expectedLimit)
        }).forEach({
            XCTAssert($0.count == 2)
            XCTAssertEqual($0[PaginationKeys.offset] as? UInt, expectedOffset)
            XCTAssertEqual($0[PaginationKeys.limit] as? UInt, expectedLimit)
        })
    }
    
    func testParametersFromOffsetAndLimitAndFilters() {
        func nodeImplementation(_ node: Node, _ offset: UInt, _ limit: UInt, _ filters: [FilterType]) -> Parameters {
            return node.parametersFrom(offset: offset, limit: limit, filters: filters)
        }
        
        func defaultImplementation(_ node: Node, _ offset: UInt, _ limit: UInt, _ filters: [FilterType]) -> Parameters {
            return Dflt.parametersFrom(node: node, offset: offset, limit: limit, filters: filters)
        }
        
        let node: Node = MockNode()
        let expectedOffset: UInt = 10
        let expectedLimit: UInt = 100
        let nameFilter: _F<String> = _F(.name, .__icontains, "blubb")
        let filters = [nameFilter]
        
        [nodeImplementation, defaultImplementation].map({
            $0(node, expectedOffset, expectedLimit, filters)
        }).forEach({
            XCTAssert($0.count == 3)
            XCTAssertEqual($0[PaginationKeys.offset] as? UInt, expectedOffset)
            XCTAssertEqual($0[PaginationKeys.limit] as? UInt, expectedLimit)
            XCTAssertEqual($0[nameFilter.stringKey] as? String, nameFilter.value as? String)
        })
    }
    
    func testParametersFromParameterConvertible() {
        func nodeImplementation(_ node: Node, _ object: ParameterConvertible, _ method: ResourceHTTPMethod) -> [String : String] {
            return node.parametersFrom(object: object, method: method) as! [String : String]
        }
        
        func defaultImplementation(_ node: Node, _ object: ParameterConvertible, _ method: ResourceHTTPMethod) -> [String : String] {
            return Dflt.parametersFrom(node: node, object: object, method: method) as! [String : String]
        }
        
        let node: Node = MockNode()
        let objectsAndExpectedParameters: [(ParameterConvertible, [String : String])] = (1..<100)
            .map({ MockListPostable(name: "\($0)") })
            .map({ ($0, $0.toParameters() as! [String : String]) })
        
        objectsAndExpectedParameters.forEach({ objectAndExpectedParameters in
            let (object, expectedParameters) = objectAndExpectedParameters
            ResourceHTTPMethod.all.forEach({ method in
                [nodeImplementation, defaultImplementation].map({
                    $0(node, object, method)
                }).forEach({
                    XCTAssertEqual($0, expectedParameters)
                })
            })
        })
    }
    
    func testParametersFromListPostables() {
        func nodeImplementation<C: Collection>(_ node: Node, _ listPostables: C) -> [String : [[String : String]]] where C.Element: ListPostable {
            return node.parametersFrom(listPostables: listPostables) as! [String : [[String : String]]]
        }
        
        func defaultImplementation<C: Collection>(_ node: Node, _ listPostables: C) -> [String : [[String : String]]] where C.Element: ListPostable {
            return Dflt.parametersFrom(node: node, listPostables: listPostables) as! [String : [[String : String]]]
        }
        
        let node: Node = MockNode()
        let objects: [MockListPostable] = (0..<100).map({ MockListPostable(name: "\($0)") })
        let expectedParameters: [String : [[String : String]]] = [
            ListRequestKeys.objects: objects.map({ $0.toParameters() as! [String : String] })
        ]
        
        [nodeImplementation, defaultImplementation].map({
            $0(node, objects)
        }).forEach({
            XCTAssertEqual($0, expectedParameters)
        })
    }
    
    // URLs
    // MetaResource.Type URLs
    func testRoutesAgainstRelativeURLForResourceType() {
        func nodeImplementation(_ node: Node, _ route: Route) -> URL {
            return node.relativeURL(for: route.resourceType, routeType: route.routeType, method: route.method)
        }
        
        func defaultImplementation(_ node: Node, _ route: Route) -> URL {
            return Dflt.relativeURL(node: node, for: route.resourceType, routeType: route.routeType, method: route.method)
        }
        
        let node: Node = MockNode()
        
        (node as! MockNode).routes = [
            .listGET(MockListGettable.self, "mocklistgettables"),
            .listGET(MockFilteredListGettable.self, "mockfilteredlistgettables"),
            .detailGET(MockDetailGettable.self, "mockdetailgettables"),
            //.listPOST(MockListPostable.self, "mocklistpostables"),
            .singlePOST(MockSinglePostable.self, "mocksinglepostables"),
            //.detailPUT(MockDetailPostable.self, "mockdetailputtables"),
            //.detailPATCH(MockDetailPatchable.self, "mockdetailpatchables"),
            //.detailDELETE(MockDetailDeletable.self, "mockdetaildeletables")
        ]
        
        node.routes.forEach({ route in
            let expectedURL: URL = route.relativeURL
            [nodeImplementation, defaultImplementation].map({
                $0(node, route)
            }).forEach({
                XCTAssertEqual($0, expectedURL)
            })
        })
    }
    
    func testRoutesAgainstAbsoluteURLForResourceType() {
        func nodeImplementation(_ node: Node, _ route: Route) -> URL {
            return node.absoluteURL(for: route.resourceType, routeType: route.routeType, method: route.method)
        }
        
        func defaultImplementation(_ node: Node, _ route: Route) -> URL {
            return Dflt.absoluteURL(node: node, for: route.resourceType, routeType: route.routeType, method: route.method)
        }
        
        let node: Node = MockNode()
        
        (node as! MockNode).routes = [
            .listGET(MockListGettable.self, "mocklistgettables"),
            .listGET(MockFilteredListGettable.self, "mockfilteredlistgettables"),
            .detailGET(MockDetailGettable.self, "mockdetailgettables"),
            //.listPOST(MockListPostable.self, "mocklistpostables"),
            .singlePOST(MockSinglePostable.self, "mocksinglepostables"),
            //.detailPUT(MockDetailPostable.self, "mockdetailputtables"),
            //.detailPATCH(MockDetailPatchable.self, "mockdetailpatchables"),
            //.detailDELETE(MockDetailDeletable.self, "mockdetaildeletables")
        ]
        
        let baseURL: URL = node.baseURL
        
        node.routes.forEach({ route in
            let expectedURL: URL = baseURL + route.relativeURL
            [nodeImplementation, defaultImplementation].map({
                $0(node, route)
            }).forEach({
                XCTAssertEqual($0, expectedURL)
            })
        })
    }

    // IdentifiableResource URLs
    func testRoutesAgainstRelativeURLForIdentifiableResource() {
        func nodeImplementation<T: IdentifiableResource>(_ node: Node, _ resource: T, method: ResourceHTTPMethod) -> URL {
            return node.relativeURL(for: resource, method: method)
        }
        
        func defaultImplementation<T: IdentifiableResource>(_ node: Node, _ resource: T, method: ResourceHTTPMethod) -> URL {
            return Dflt.relativeURL(node: node, for: resource, method: method)
        }
        
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
        
        allRoutesAndObjects.forEach({ routeAndObjects in
            let route: Route = routeAndObjects.0
            let objects = routeAndObjects.1
            let method: ResourceHTTPMethod = route.method
            let listURL: URL = route.relativeURL
            
            objects.forEach({ object in
                let expectedURL: URL = listURL + object.id.string
                [nodeImplementation, defaultImplementation].map({
                    $0(node, object, method)
                }).forEach({
                    XCTAssertEqual($0, expectedURL)
                })
            })
        })
    }
    
    func testRoutesAgainstAbsoluteURLForIdentifiableResource() {
        func nodeImplementation<T: IdentifiableResource>(_ node: Node, _ resource: T, method: ResourceHTTPMethod) -> URL {
            return node.absoluteURL(for: resource, method: method)
        }
        
        func defaultImplementation<T: IdentifiableResource>(_ node: Node, _ resource: T, method: ResourceHTTPMethod) -> URL {
            return Dflt.absoluteURL(node: node, for: resource, method: method)
        }
        
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
        
        let baseURL: URL = node.baseURL
        
        allRoutesAndObjects.forEach({ routeAndObjects in
            let route: Route = routeAndObjects.0
            let objects = routeAndObjects.1
            let method: ResourceHTTPMethod = route.method
            let listURL: URL = baseURL + route.relativeURL
            
            objects.forEach({ object in
                let expectedURL: URL = listURL + object.id.string
                [nodeImplementation, defaultImplementation].map({
                    $0(node, object, method)
                }).forEach({
                    XCTAssertEqual($0, expectedURL)
                })
            })
        })

    }
    
    // ResourceID URLs
    func testRoutesAgainstRelativeGETURLForResourceID() {
        func nodeImplementation<T: DetailGettable>(_ node: Node, _ resourceID: ResourceID<T>) -> URL {
            return node.relativeGETURL(for: resourceID)
        }
        
        func defaultImplementation<T: DetailGettable>(_ node: Node, _ resourceID: ResourceID<T>) -> URL {
            return Dflt.relativeGETURL(node: node, for: resourceID)
        }
        
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
        
        allRoutesAndResourceIDs.forEach({ routeAndResourceIDs in
            let route: Route = routeAndResourceIDs.0
            let resourceIDs: [ResourceID] = routeAndResourceIDs.1
            let listURL: URL = route.relativeURL
            
            resourceIDs.forEach({ resourceID in
                let expectedURL: URL = listURL + resourceID.string
                [nodeImplementation, defaultImplementation].map({
                    $0(node, resourceID)
                }).forEach({
                    XCTAssertEqual($0, expectedURL)
                })
            })
        })
    }
    
    func testRoutesAgainstAbsoluteGETURLForResourceID() {
        func nodeImplementation<T: DetailGettable>(_ node: Node, _ resourceID: ResourceID<T>) -> URL {
            return node.absoluteGETURL(for: resourceID)
        }
        
        func defaultImplementation<T: DetailGettable>(_ node: Node, _ resourceID: ResourceID<T>) -> URL {
            return Dflt.absoluteGETURL(node: node, for: resourceID)
        }
        
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
        
        let baseURL: URL = node.baseURL
        
        allRoutesAndResourceIDs.forEach({ routeAndResourceIDs in
            let route: Route = routeAndResourceIDs.0
            let resourceIDs: [ResourceID] = routeAndResourceIDs.1
            let listURL: URL = baseURL + route.relativeURL
            
            resourceIDs.forEach({ resourceID in
                let expectedURL: URL = listURL + resourceID.string
                [nodeImplementation, defaultImplementation].map({
                    $0(node, resourceID)
                }).forEach({
                    XCTAssertEqual($0, expectedURL)
                })
            })
        })
    }
    
    // Response Extraction
    // Detail Response Extraction Helpers
    func testExtractSingleObject() {
        func nodeImplementation<T: JSONInitializable>(_ node: Node, _ resourceType: T.Type, _ method: ResourceHTTPMethod, _ json: JSON) -> T {
            return node.extractSingleObject(for: resourceType, method: method, from: json)
        }
        
        func defaultImplementation<T: JSONInitializable>(_ node: Node, _ resourceType: T.Type, _ method: ResourceHTTPMethod, _ json: JSON) -> T {
            return Dflt.extractSingleObject(node: node, for: resourceType, method: method, from: json)
        }
        
        let node: Node = MockNode()
        let fixtureType = MockListGettable.self
        let jsonFixturesAndExpectedObjects = (0..<100)
            .map({ JSON([fixtureType.Keys.name : "\($0)"]) })
            .map({ ($0, fixtureType.init(json: $0)) })
        
        jsonFixturesAndExpectedObjects.forEach({ jsonFixtureAndExpectedObject in
            let (jsonFixture, expectedObject) = jsonFixtureAndExpectedObject
            ResourceHTTPMethod.all.forEach({ method in
                [nodeImplementation, defaultImplementation].map({
                    $0(node, fixtureType, method, jsonFixture)
                }).forEach({
                    XCTAssertEqual($0, expectedObject)
                })
            })
        })
    }
    
    // List Response Extraction Helpers
    func testExtractGETListResponsePagination() {
        func nodeImplementation<T: Pagination>(_ node: Node, _ paginationType: T.Type, _ json: JSON) -> Pagination {
            return node.extractGETListResponsePagination(with: paginationType, from: json)
        }
        
        func defaultImplementation<T: Pagination>(_ node: Node, _ paginationType: T.Type, _ json: JSON) -> Pagination {
            return Dflt.extractGETListResponsePagination(node: node, with: paginationType, from: json)
        }
        
        let node: Node = MockNode()
        
        let paginationType = DefaultPagination.self
        
        let expectedLimit: UInt = 100
        let expectedNext: URL = URL(string: "url/to/next/page")!
        let expectedOffset: UInt = 10
        let expectedPrevious: URL = URL(string: "url/to/previous/page")!
        let expectedTotalCount: UInt = 1000
        
        let jsonFixture: JSON = JSON([
            ListResponseKeys.meta: [
                PaginationKeys.limit: expectedLimit,
                PaginationKeys.next: expectedNext.absoluteString,
                PaginationKeys.offset: expectedOffset,
                PaginationKeys.previous: expectedPrevious.absoluteString,
                PaginationKeys.totalCount: expectedTotalCount,
            ]
        ])
        
        [nodeImplementation, defaultImplementation].map({
            $0(node, paginationType, jsonFixture)
        }).forEach({ pagination in
            XCTAssertEqual(pagination.limit, expectedLimit)
            XCTAssertEqual(pagination.next, expectedNext)
            XCTAssertEqual(pagination.offset, expectedOffset)
            XCTAssertEqual(pagination.previous, expectedPrevious)
            XCTAssertEqual(pagination.totalCount, expectedTotalCount)
        })
    }
    
    func testExtractGETListResponseObjects() {
        func nodeImplementation<T: ListGettable>(_ node: Node, _ resourceType: T.Type, _ json: JSON) -> [T] {
            return node.extractGETListResponseObjects(for: resourceType, from: json)
        }
        
        func defaultImplementation<T: ListGettable>(_ node: Node, _ resourceType: T.Type, _ json: JSON) -> [T] {
            return Dflt.extractGETListResponseObjects(node: node, for: resourceType, from: json)
        }
        
        let node: Node = MockNode()
        let fixtureType = MockListGettable.self
        let expectedResults = (0..<100).map({ fixtureType.init(name: "\($0)") })
        
        let jsonFixture: JSON = JSON([
            ListResponseKeys.results: expectedResults.map({ [fixtureType.Keys.name : $0.name] })
        ])
        
        [nodeImplementation, defaultImplementation].map({
            $0(node, fixtureType, jsonFixture)
        }).forEach({
            XCTAssertEqual($0, expectedResults)
        })
    }
    
    func testExtractGETListResponse() {
        func nodeImplementation<T: ListGettable>(_ node: Node, _ resourceType: T.Type, _ json: JSON) -> (Pagination, [T]) {
            return node.extractGETListResponse(for: resourceType, from: json)
        }
        
        func defaultImplementation<T: ListGettable>(_ node: Node, _ resourceType: T.Type, _ json: JSON) -> (Pagination, [T]) {
            return Dflt.extractGETListResponse(node: node, for: resourceType, from: json)
        }
        
        let node: Node = MockNode()

        let fixtureType = MockListGettable.self
        
        let expectedLimit: UInt = 100
        let expectedNext: URL = URL(string: "url/to/next/page")!
        let expectedOffset: UInt = 10
        let expectedPrevious: URL = URL(string: "url/to/previous/page")!
        let expectedTotalCount: UInt = 1000
        let expectedResults = (0..<100).map({ fixtureType.init(name: "\($0)") })
        
        let jsonFixture: JSON = JSON([
            ListResponseKeys.meta: [
                PaginationKeys.limit: expectedLimit,
                PaginationKeys.next: expectedNext.absoluteString,
                PaginationKeys.offset: expectedOffset,
                PaginationKeys.previous: expectedPrevious.absoluteString,
                PaginationKeys.totalCount: expectedTotalCount,
            ],
            ListResponseKeys.results: expectedResults.map({ [fixtureType.Keys.name : $0.name] })
        ])
        
        [nodeImplementation, defaultImplementation].map({
            $0(node, fixtureType, jsonFixture)
        }).forEach({ listResponse in
            let (pagination, results) = listResponse
            
            XCTAssertEqual(pagination.limit, expectedLimit)
            XCTAssertEqual(pagination.next, expectedNext)
            XCTAssertEqual(pagination.offset, expectedOffset)
            XCTAssertEqual(pagination.previous, expectedPrevious)
            XCTAssertEqual(pagination.totalCount, expectedTotalCount)
            
            XCTAssertEqual(results, expectedResults)
        })
    }
    
    func testExtractPOSTListResponse() {
        func nodeImplementation<T: ListPostable>(_ node: Node, _ resourceType: T.Type, _ json: JSON) -> [T] {
            return node.extractPOSTListResponse(for: resourceType, from: json)
        }
        
        func defaultImplementation<T: ListPostable>(_ node: Node, _ resourceType: T.Type, _ json: JSON) -> [T] {
            return Dflt.extractPOSTListResponse(node: node, for: resourceType, from: json)
        }
        
        let node: Node = MockNode()
        let fixtureType = MockListPostable.self
        let expectedResults = (0..<100).map({ fixtureType.init(name: "\($0)") })
        let jsonFixture: JSON = JSON([
            ListResponseKeys.results: expectedResults.map({ [fixtureType.Keys.name : $0.name] })
        ])
        
        [nodeImplementation, defaultImplementation].map({
            $0(node, fixtureType, jsonFixture)
        }).forEach({
            XCTAssertEqual($0, expectedResults)
        })
    }
}
