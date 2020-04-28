//
//  Dictionary (merging) Tests.swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 27.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import DjangoConsumer


// MARK: -
class Dictionary_merging_Tests: BaseTest {
    func testInitWithKeepOldValueStrategy() {
        let ary: [(String, String)] = [
            ("foo", "bar"),
            ("baz", "boing"),
            ("foo", "blubb"),
            ("something", "else"),
        ]
        
        let dict: [String: String] = Dictionary(ary, strategy: .keepOldValue)
        
        let expectedDict: [String: String] = [
            "foo": "bar",
            "baz": "boing",
            "something": "else",
        ]
        
        XCTAssertEqual(dict, expectedDict)
    }
    
    func testInitWithOverwriteOldValueStrategy() {
        let ary: [(String, String)] = [
            ("foo", "bar"),
            ("baz", "boing"),
            ("foo", "blubb"),
            ("something", "else"),
        ]
        
        let dict: [String: String] = Dictionary(ary, strategy: .overwriteOldValue)
        
        let expectedDict: [String: String] = [
            "foo": "blubb",
            "baz": "boing",
            "something": "else",
        ]
        
        XCTAssertEqual(dict, expectedDict)
    }
    
    func testMergingWithKeepOldValueStrategy() {
        let dictA: [String: String] = [
            "foo": "bar",
            "baz": "boing",
        ]
        
        let dictB: [String: String] = [
            "foo": "blubb",
            "something": "else",
        ]
        
        let expectedMerged: [String: String] = [
            "foo": "bar",
            "baz": "boing",
            "something": "else",
        ]
        
        let merged: [String: String] = dictA.merging(dictB, strategy: .keepOldValue)
        
        XCTAssertEqual(merged, expectedMerged)
    }
    
    func testMergingWithOverwriteOldValueStrategy() {
        let dictA: [String: String] = [
            "foo": "bar",
            "baz": "boing",
        ]
        
        let dictB: [String: String] = [
            "foo": "blubb",
            "something": "else",
        ]
        
        let expectedMerged: [String: String] = [
            "foo": "blubb",
            "baz": "boing",
            "something": "else",
        ]
        
        let merged: [String: String] = dictA.merging(dictB, strategy: .overwriteOldValue)
        
        XCTAssertEqual(merged, expectedMerged)
    }
    
    func testInPlaceMergeWithKeepOldValueStrategy() {
        var dictA: [String: String] = [
            "foo": "bar",
            "baz": "boing",
        ]
        
        let dictB: [String: String] = [
            "foo": "blubb",
            "something": "else",
        ]
        
        let expectedMerged: [String: String] = [
            "foo": "bar",
            "baz": "boing",
            "something": "else",
        ]
        
        dictA.merge(dictB, strategy: .keepOldValue)
        
        XCTAssertEqual(dictA, expectedMerged)
    }
    
    func testInPlaceMergeWithOverwriteOldValueStrategy() {
        var dictA: [String: String] = [
            "foo": "bar",
            "baz": "boing",
        ]
        
        let dictB: [String: String] = [
            "foo": "blubb",
            "something": "else",
        ]
        
        let expectedMerged: [String: String] = [
            "foo": "blubb",
            "baz": "boing",
            "something": "else",
        ]
        
        dictA.merge(dictB, strategy: .overwriteOldValue)
        
        XCTAssertEqual(dictA, expectedMerged)
    }
}
