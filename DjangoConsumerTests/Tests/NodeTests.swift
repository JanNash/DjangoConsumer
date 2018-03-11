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
import DjangoConsumer


// MARK: // Internal
class NodeTests: BaseTest {
    func testDefaultFilters() {
        let node: Node = MockNode()
        XCTAssert(node.defaultFilters(for: MockFilteredListGettable.self).isEmpty)
    }
    
    func testDefaultPaginationType() {
        let node: Node = MockNode()
        typealias FixtureType = MockListGettable
        
        let nodeImplementation: (ResourceHTTPMethod) -> Pagination.Type = {
            node.paginationType(for: FixtureType.self, with: $0)
        }
        
        let defaultImplementation: (ResourceHTTPMethod) -> Pagination.Type = {
            DefaultImplementations._Node_.paginationType(node: node, for: FixtureType.self, with: $0)
        }
        
        ResourceHTTPMethod.all.forEach({
            XCTAssert(nodeImplementation($0) == DefaultPagination.self)
            XCTAssert(defaultImplementation($0) == DefaultPagination.self)
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
            DefaultImplementations._Node_.parametersFrom(node: node, offset: expectedOffset, limit: expectedLimit)
        }
        
        [nodeImplementation, defaultImplementation].forEach({
            let parameters: Parameters = $0()
            XCTAssert(parameters.count == 2)
            XCTAssertEqual(parameters[DefaultPagination.Keys.offset] as? UInt, expectedOffset)
            XCTAssertEqual(parameters[DefaultPagination.Keys.limit] as? UInt, expectedLimit)
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
            DefaultImplementations._Node_.parametersFrom(node: node, offset: expectedOffset, limit: expectedLimit, filters: filters)
        }
        
        [nodeImplementation, defaultImplementation].forEach({
            let parameters: Parameters = $0()
            XCTAssert(parameters.count == 3)
            XCTAssertEqual(parameters[DefaultPagination.Keys.offset] as? UInt, expectedOffset)
            XCTAssertEqual(parameters[DefaultPagination.Keys.limit] as? UInt, expectedLimit)
            XCTAssertEqual(parameters[nameFilter.stringKey] as? String, nameFilter.value as? String)
        })
    }
    
    func testRoutesAgainstRelativeURLForResourceType() {
        let mockNode: MockNode = MockNode()
        let node: Node = mockNode
        
        let routes: [Route] = [
            .listGET(MockListGettable.self, "mocklistgettables"),
            .listGET(MockFilteredListGettable.self, "mockfilteredlistgettables"),
            // .detailGET(MockDetailGettable.self, "mockdetailgettables"),
            // .listPOST(MockListPostable.self, "mocklistpostables"),
            .singlePOST(MockSinglePostable.self, "mocksinglepostables"),
            // .detailPUT(MockDetailPostable.self, "mockdetailputtables"),
            // .detailPATCH(MockDetailPatchable.self, "mockdetailpatchables"),
            // .detailDELETE(MockDetailDeletable.self, "mockdetaildeletables")
        ]
        
        mockNode.routes = routes
        
        let nodeImplementation: (MetaResource.Type, RouteType, ResourceHTTPMethod) -> URL = {
            node.relativeURL(for: $0, routeType: $1, method: $2)
        }
        
        let defaultImplementation: (MetaResource.Type, RouteType, ResourceHTTPMethod) -> URL = {
            DefaultImplementations._Node_.relativeURL(node: node, for: $0, routeType: $1, method: $2)
        }
        
        routes.forEach({
            let expectedURL: URL = $0.relativeURL
            let typ: MetaResource.Type = $0.resourceType
            let routeType: RouteType = $0.routeType
            let method: ResourceHTTPMethod = $0.method
            
            let nodeRelativeURL: URL = nodeImplementation(typ, routeType, method)
            XCTAssertEqual(nodeRelativeURL, expectedURL)
            
            let defaultRelativeURL: URL = defaultImplementation(typ, routeType, method)
            XCTAssertEqual(defaultRelativeURL, expectedURL)
        })
    }
    
    func testRoutesAgainstAbsoluteURLForResourceType() {
        let mockNode: MockNode = MockNode()
        let node: Node = mockNode
        
        let routes: [Route] = [
            .listGET(MockListGettable.self, "mocklistgettables"),
            .listGET(MockFilteredListGettable.self, "mockfilteredlistgettables"),
            // .detailGET(MockDetailGettable.self, "mockdetailgettables"),
            // .listPOST(MockListPostable.self, "mocklistpostables"),
            .singlePOST(MockSinglePostable.self, "mocksinglepostables"),
            // .detailPUT(MockDetailPostable.self, "mockdetailputtables"),
            // .detailPATCH(MockDetailPatchable.self, "mockdetailpatchables"),
            // .detailDELETE(MockDetailDeletable.self, "mockdetaildeletables")
        ]
        
        mockNode.routes = routes
        
        let nodeImplementation: (MetaResource.Type, RouteType, ResourceHTTPMethod) -> URL = {
            node.absoluteURL(for: $0, routeType: $1, method: $2)
        }
        
        let defaultImplementation: (MetaResource.Type, RouteType, ResourceHTTPMethod) -> URL = {
            DefaultImplementations._Node_.absoluteURL(node: node, for: $0, routeType: $1, method: $2)
        }
        
        let baseURL: URL = node.baseURL
        
        routes.forEach({
            let expectedURL: URL = baseURL.appendingPathComponent($0.relativeURL.absoluteString)
            let typ: MetaResource.Type = $0.resourceType
            let routeType: RouteType = $0.routeType
            let method: ResourceHTTPMethod = $0.method
            
            let nodeAbsoluteURL: URL = nodeImplementation(typ, routeType, method)
            XCTAssertEqual(nodeAbsoluteURL, expectedURL)
            
            let defaultAbsoluteURL: URL = defaultImplementation(typ, routeType, method)
            XCTAssertEqual(defaultAbsoluteURL, expectedURL)
        })
    }
}
