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
// MARK: StaticLetTests
class StaticLetTests: BaseTest {
    // Node.swift
    func testDefaultListRequestKeys() {
        typealias FixtureType = DefaultImplementations._Node_.ListRequestKeys
        
        XCTAssertEqual(FixtureType.objects, "objects")
    }
    
    func testDefaultListResponseKeys() {
        typealias FixtureType = DefaultImplementations._Node_.ListResponseKeys
        
        XCTAssertEqual(FixtureType.meta, "meta")
        XCTAssertEqual(FixtureType.results, "results")
    }
    
    // Pagination.swift
    func testDefaultPaginationKeys() {
        typealias FixtureType = DefaultPagination.Keys
        
        XCTAssertEqual(FixtureType.limit, "limit")
        XCTAssertEqual(FixtureType.next, "next")
        XCTAssertEqual(FixtureType.offset, "offset")
        XCTAssertEqual(FixtureType.previous, "previous")
        XCTAssertEqual(FixtureType.totalCount, "total_count")
    }
    
    // OAuth2Constants.swift
    func testOAuth2Constants() {
        typealias FixtureType = OAuth2Constants
        
        XCTAssertEqual(FixtureType.JSONKeys.accessToken, "access_token")
        XCTAssertEqual(FixtureType.JSONKeys.refreshToken, "refresh_token")
        XCTAssertEqual(FixtureType.JSONKeys.expiresIn, "expires_in")
        XCTAssertEqual(FixtureType.JSONKeys.grantType, "grant_type")
        XCTAssertEqual(FixtureType.JSONKeys.scope, "scope")
        XCTAssertEqual(FixtureType.JSONKeys.username, "username")
        XCTAssertEqual(FixtureType.JSONKeys.password, "password")
        XCTAssertEqual(FixtureType.JSONKeys.token, "token")
        XCTAssertEqual(FixtureType.JSONKeys.tokenType, "token_type")
        
        XCTAssertEqual(FixtureType.GrantTypes.password, "password")
        XCTAssertEqual(FixtureType.GrantTypes.refreshToken, "refresh_token")
        
        XCTAssertEqual(FixtureType.Scopes.readWrite, "read write")
        
        XCTAssertEqual(FixtureType.HeaderFields.authorization, "Authorization")
        
        let fakeToken: String = "Wibbly wobbly, timey wimey"
        XCTAssertEqual(FixtureType.HeaderValues.basic(fakeToken), "Basic \(fakeToken)")
        XCTAssertEqual(FixtureType.HeaderValues.bearer(fakeToken), "Bearer \(fakeToken)")
    }
}


// MARK: EnumTests
class EnumTests: BaseTest {
    // Route.swift
    func testRouteType() {
        typealias FixtureType = RouteType
        
        XCTAssertEqual(FixtureType.detail.rawValue, "detail")
        XCTAssertEqual(FixtureType.list.rawValue, "list")
    }
    
    // Filtering.swift
    func testFilterKey() {
        typealias FixtureType = FilterKey<Any>.DefaultFilterKeys
        
        XCTAssertEqual(FixtureType.date.rawValue, "date")
        XCTAssertEqual(FixtureType.id.rawValue, "id")
        XCTAssertEqual(FixtureType.name.rawValue, "name")
        
        XCTAssertEqual(FilterKey<Date>.date.string, "date")
        XCTAssertEqual(FilterKey<id_Type>.id.string, "id")
        XCTAssertEqual(FilterKey<String>.name.string, "name")
    }
    
    func testFilterComparator() {
        typealias FixtureType = FilterComparator.DefaultFilterComparators
        
        XCTAssertEqual(FixtureType.__gt.rawValue, "__gt")
        XCTAssertEqual(FixtureType.__gte.rawValue, "__gte")
        XCTAssertEqual(FixtureType.__icontains.rawValue, "__icontains")
        XCTAssertEqual(FixtureType.__in.rawValue, "__in")
        XCTAssertEqual(FixtureType.__lt.rawValue, "__lt")
        XCTAssertEqual(FixtureType.__lte.rawValue, "__lte")
    }
    
    // ResourceHTTPMethod.swift
    func testResourceHTTPMethod() {
        typealias FixtureType = ResourceHTTPMethod
        
        XCTAssertEqual(FixtureType.get.rawValue, "GET")
        XCTAssertEqual(FixtureType.head.rawValue, "HEAD")
        XCTAssertEqual(FixtureType.post.rawValue, "POST")
        XCTAssertEqual(FixtureType.put.rawValue, "PUT")
        XCTAssertEqual(FixtureType.patch.rawValue, "PATCH")
        XCTAssertEqual(FixtureType.delete.rawValue, "DELETE")
        
        XCTAssertEqual(
            FixtureType.all, [.get, .head, .post, .put, .patch, .delete]
        )
        
        XCTAssertEqual(
            FixtureType.all.map({ $0.toHTTPMethod() }),
            [.get, .head, .post, .put, .patch, .delete]
        )
    }
}
