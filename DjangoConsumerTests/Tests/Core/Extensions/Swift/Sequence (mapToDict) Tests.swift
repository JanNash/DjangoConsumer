//
//  Sequence (mapToDict) Tests.swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 28.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import DjangoConsumer


// MARK: -
class Sequence_mapToDict_Tests: BaseTest {
    func testMapToDictWithoutTransformWithKeepOldValueStrategy() {
        let ary: [(String, String)] = [
            ("1", "1"),
            ("1", "2"),
            ("1", "3"),
            ("1", "4"),
        ]
        
        let mappedDict: [String: String] = ary.mapToDict(strategy: .keepOldValue)
        
        XCTAssertEqual(mappedDict, ["1": "1"])
    }
    
    func testMapToDictWithoutTransformWithOverwriteOldValueStrategy() {
        let ary: [(String, String)] = [
            ("1", "1"),
            ("1", "2"),
            ("1", "3"),
            ("1", "4"),
        ]
        
        let mappedDict: [String: String] = ary.mapToDict(strategy: .overwriteOldValue)
        
        XCTAssertEqual(mappedDict, ["1": "4"])
    }
    
    func testMapToDictWithFullTransformWithKeepOldValueStrategy() {
        let ary: [(Int, Int)] = [
            (1, 1),
            (1, 2),
            (1, 3),
            (1, 4),
        ]
        
        let mappedDict: [String: String] = ary.mapToDict({ ("\($0.0)", "\($0.1)") }, strategy: .keepOldValue)
        
        XCTAssertEqual(mappedDict, ["1": "1"])
    }
    
    func testMapToDictWithFullTransformWithOverwriteOldValueStrategy() {
        let ary: [(Int, Int)] = [
            (1, 1),
            (1, 2),
            (1, 3),
            (1, 4),
        ]
        
        let mappedDict: [String: String] = ary.mapToDict({ ("\($0.0)", "\($0.1)") }, strategy: .overwriteOldValue)
        
        XCTAssertEqual(mappedDict, ["1": "4"])
    }
    
    func testMapToDictWithValueTransformWithKeepOldValueStrategy() {
        let ary: [(String, Int)] = [
            ("1", 1),
            ("1", 2),
            ("1", 3),
            ("1", 4),
        ]
        
        let mappedDict: [String: String] = ary.mapToDict({ "\($0)" }, strategy: .keepOldValue)
        
        XCTAssertEqual(mappedDict, ["1": "1"])
    }
    
    func testMapToDictWithValueTransformWithOverwriteOldValueStrategy() {
        let ary: [(String, Int)] = [
            ("1", 1),
            ("1", 2),
            ("1", 3),
            ("1", 4),
        ]
        
        let mappedDict: [String: String] = ary.mapToDict({ "\($0)" }, strategy: .overwriteOldValue)
        
        XCTAssertEqual(mappedDict, ["1": "4"])
    }
}
