//
//  ContainsTests.swift
//  Collections
//
//  Created by Christian Otkjær on 18/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import XCTest

@testable import Collections

class ContainsTests: XCTestCase
{
    let arrays: [[Int]] = [[], [1,2,3], [2,3], [3,4], [2,3,4]]
    
    let expectations =
        [[true, false, false, false, false],
         [true, true, true, false, false],
         [true, false, true, false, false],
         [true, false, false, true, false],
         [true, false, true, true, true]]
    
    func test_contains()
    {
        let sets = arrays.map({ Set($0) })

        for (i, expectations_for_i) in expectations.enumerated()
        {
            for (j, expectation) in expectations_for_i.enumerated()
            {
                print("\(arrays[i]) should " + (expectation ? "":"NOT ") + "contain \(arrays[j])")
                XCTAssertEqual(arrays[i].contains(arrays[j]), expectation)
                XCTAssertEqual(sets[i].contains(sets[j]), expectation)
                XCTAssertEqual(arrays[i].contains(sets[j]), expectation)
                XCTAssertEqual(sets[i].contains(arrays[j]), expectation)
            }
        }
    }
}
