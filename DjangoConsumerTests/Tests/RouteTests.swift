//
//  RouteTests.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 11.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import DjangoConsumer


// MARK: // Internal
class RouteTests: BaseTest {
    func testListGETRoute() {
        typealias FixtureType = MockListGettable
        let relPath: String = "mocklistgettables"
        
        let route: Route = .listGET(FixtureType.self, relPath)
        
        XCTAssert(route.resourceType == FixtureType.self)
        XCTAssert(route.routeType == .list)
        XCTAssert(route.method == .get)
        XCTAssert(route.relativeURL == URL(string: relPath)!)
    }
}
