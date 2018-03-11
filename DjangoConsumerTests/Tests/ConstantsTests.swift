//
//  ConstantsTests.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 12.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import DjangoConsumer


// MARK: // Internal
class ConstantsTests: BaseTest {
    func testDefaultPaginationKeys() {
        typealias FixtureType = DefaultPagination.Keys
        
        XCTAssertEqual(FixtureType.limit, "limit")
        XCTAssertEqual(FixtureType.next, "next")
        XCTAssertEqual(FixtureType.offset, "offset")
        XCTAssertEqual(FixtureType.previous, "previous")
        XCTAssertEqual(FixtureType.totalCount, "total_count")
    }
    
    func testDefaultListResponseKeys() {
        typealias FixtureType = DefaultListResponseKeys
        
        XCTAssertEqual(FixtureType.meta, "meta")
        XCTAssertEqual(FixtureType.results, "results")
    }
    
    func testResourceHTTPMethodRawValues() {
        typealias FixtureType = ResourceHTTPMethod
        
        XCTAssertEqual(FixtureType.get.rawValue, "GET")
        XCTAssertEqual(FixtureType.head.rawValue, "HEAD")
        XCTAssertEqual(FixtureType.post.rawValue, "POST")
        XCTAssertEqual(FixtureType.put.rawValue, "PUT")
        XCTAssertEqual(FixtureType.patch.rawValue, "PATCH")
        XCTAssertEqual(FixtureType.delete.rawValue, "DELETE")
    }
    
    func testOAuth2Constants() {
        typealias FixtureType = OAuth2Constants
        
        XCTAssertEqual(FixtureType.GrantTypes.password, "password")
        XCTAssertEqual(FixtureType.GrantTypes.refreshToken, "refresh_token")
        
        XCTAssertEqual(FixtureType.HeaderFields.authorization, "Authorization")
        
        let fakeToken: String = "wibbly-wobbly-timey-whimey"
        XCTAssertEqual(FixtureType.HeaderValues.basic(fakeToken), "Basic \(fakeToken)")
        XCTAssertEqual(FixtureType.HeaderValues.bearer(fakeToken), "Bearer \(fakeToken)")
        
        XCTAssertEqual(FixtureType.JSONKeys.accessToken, "access_token")
        XCTAssertEqual(FixtureType.JSONKeys.refreshToken, "refresh_token")
        XCTAssertEqual(FixtureType.JSONKeys.expiresIn, "expires_in")
        XCTAssertEqual(FixtureType.JSONKeys.grantType, "grant_type")
        XCTAssertEqual(FixtureType.JSONKeys.scope, "scope")
        XCTAssertEqual(FixtureType.JSONKeys.username, "username")
        XCTAssertEqual(FixtureType.JSONKeys.password, "password")
        XCTAssertEqual(FixtureType.JSONKeys.token, "token")
        XCTAssertEqual(FixtureType.JSONKeys.tokenType, "token_type")
        
        XCTAssertEqual(FixtureType.Scopes.readWrite, "read write")
    }
    
    func testRouteTypesRawValues() {
        typealias FixtureType = RouteType
        
        XCTAssertEqual(FixtureType.detail.rawValue, "detail")
        XCTAssertEqual(FixtureType.list.rawValue, "list")
    }
}
