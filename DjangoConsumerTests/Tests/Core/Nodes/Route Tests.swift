//
//  Route Tests.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 11.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
@testable import DjangoConsumer


// MARK: // Internal
class RouteTests: BaseTest {
    func testStaticConstantRouteTypes() {
        typealias FixtureType = RouteType
        
        let routeTypesForMethods: [(RouteType, ResourceHTTPMethod)] = [
            (.listGET, .get),
            (.listPOST, .post),
            (.detailGET, .get),
            (.singlePOST, .post),
            (.detailPUT, .put),
            (.detailPATCH, .patch),
            (.detailDELETE, .delete),
        ]
        
        for element in routeTypesForMethods {
            XCTAssertEqual(element.0.method, element.1)
        }
    }
    
    func testRouteEquatability1() {
        typealias FixtureType = MockListGettable
        XCTAssertEqual(Route.listGET(FixtureType.self, "a"), Route.listGET(FixtureType.self, "b"))
    }
    
    func testRouteEquatability2() {
        XCTAssertNotEqual(Route.listGET(MockListGettable.self, "a"), Route.detailGET(MockDetailGettable.self, "b"))
    }
    
    func testRouteHashValue1() {
        typealias FixtureType = MockListGettable
        XCTAssertEqual(Route.listGET(FixtureType.self, "a").hashValue, Route.listGET(FixtureType.self, "b").hashValue)
    }
    
    func testRouteHashValue2() {
        XCTAssertNotEqual(Route.listGET(MockListGettable.self, "a").hashValue, Route.detailGET(MockDetailGettable.self, "b").hashValue)
    }
    
    func testRouteMatchesListGET() {
        typealias FixtureType = MockListGettable
        XCTAssert(Route.matches(FixtureType.self, .listGET)(Route.listGET(FixtureType.self, "a")))
    }
    
    func testRouteMatchesDetailGET() {
        typealias FixtureType = MockDetailGettable
        XCTAssert(Route.matches(FixtureType.self, .detailGET)(Route.detailGET(FixtureType.self, "a")))
    }
    
    func testRouteMatchesSinglePOST() {
        typealias FixtureType = MockSinglePostable
        XCTAssert(Route.matches(FixtureType.self, .singlePOST)(Route.singlePOST(FixtureType.self, "a")))
    }
    
    func testListGETRoute() {
        typealias FixtureType = MockListGettable
        let relPath: String = "mocklistgettables"
        
        let route: Route = .listGET(FixtureType.self, relPath)
        
        XCTAssert(route.resourceType == FixtureType.self)
        XCTAssert(route.routeType == .listGET)
        XCTAssert(route.relativeURL == URL(string: relPath)!)
    }
    
    func testDetailGETRoute() {
        typealias FixtureType = MockDetailGettable
        let relPath: String = "mockdetailgettables"
        
        let route: Route = .detailGET(FixtureType.self, relPath)
        
        XCTAssert(route.resourceType == FixtureType.self)
        XCTAssert(route.routeType == .detailGET)
        XCTAssert(route.relativeURL == URL(string: relPath)!)
    }
    
    func testListPostRoute() {
        typealias FixtureType = MockListPostable
        let relPath: String = "mocklistpostables"
        
        let route: Route = .listPOST(FixtureType.self, relPath)
        
        XCTAssert(route.resourceType == FixtureType.self)
        XCTAssert(route.routeType == .listPOST)
        XCTAssert(route.relativeURL == URL(string: relPath)!)
    }
    
    func testSinglePostRoute() {
        typealias FixtureType = MockSinglePostable
        let relPath: String = "mocksinglepostables"
        
        let route: Route = .singlePOST(FixtureType.self, relPath)
        
        XCTAssert(route.resourceType == FixtureType.self)
        XCTAssert(route.routeType == .singlePOST)
        XCTAssert(route.relativeURL == URL(string: relPath)!)
    }
}
