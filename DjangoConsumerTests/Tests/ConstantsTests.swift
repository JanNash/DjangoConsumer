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
import Alamofire
@testable import DjangoConsumer


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
        
        let allResourceHTTPMethods: [FixtureType] = FixtureType.all
        XCTAssertEqual(allResourceHTTPMethods, [.get, .head, .post, .put, .patch, .delete])
        
        let allHTTPMethods: [HTTPMethod] = [.get, .head, .post, .put, .patch, .delete]
        XCTAssertEqual(allResourceHTTPMethods.map({ $0.toHTTPMethod() }), allHTTPMethods)
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
    
    func testFilterKeyConstants() {
        typealias FixtureType = FilterKey<Any>.DefaultFilterKeys
        
        XCTAssertEqual(FixtureType.date.rawValue, "date")
        XCTAssertEqual(FixtureType.id.rawValue, "id")
        XCTAssertEqual(FixtureType.name.rawValue, "name")
        
        let date: FilterKey = .date
        XCTAssertEqual(date.string, "date")
        
        let _id: FilterKey = .id
        XCTAssertEqual(_id.string, "id")
        
        let name: FilterKey = .name
        XCTAssertEqual(name.string, "name")
    }
    
    func testFilterComparatorConstants() {
        typealias FixtureType = FilterComparator.DefaultFilterComparators
        
        XCTAssertEqual(FixtureType.__gt.rawValue, "__gt")
        XCTAssertEqual(FixtureType.__gte.rawValue, "__gte")
        XCTAssertEqual(FixtureType.__icontains.rawValue, "__icontains")
        XCTAssertEqual(FixtureType.__in.rawValue, "__in")
        XCTAssertEqual(FixtureType.__lt.rawValue, "__lt")
        XCTAssertEqual(FixtureType.__lte.rawValue, "__lte")
    }
}
