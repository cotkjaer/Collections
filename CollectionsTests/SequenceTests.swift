//
//  SequenceTypeTests.swift
//  Collections
//
//  Created by Christian Otkjær on 16/09/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import XCTest
import Foundation
@testable import Collections

class SequenceTypeTests: XCTestCase {

    func testUniques() {
        XCTAssertEqual([1,6,7,4,3,2,1,2,3,1,3,4,0].uniques, [1,6,7,4,3,2,0])
    }

    func testJoinedWithSeparatorPrefixSuffix()
    {
        XCTAssertEqual(["foo", "bar", "baz"].joinedWithSeparator("-", prefix: "O", suffix:""), "Ofoo-Obar-Obaz")
    }
    
    func test_cycle()
    {
        let set = Set(arrayLiteral: 1,2,3)
        
        var counter = 0
        
        set.cycle(3) { counter += $0 }
        
        XCTAssertEqual(counter, 18)
    }
    
    func test_first()
    {
        let array = [1,2,3,4,5,6,7,9,10]
        
        XCTAssertEqual(array.first(where: { $0 == 7 }), 7)
        XCTAssertNil(array.first(where: { $0 == 8 }))
        
        XCTAssertNil(array.first(-1))
        XCTAssertEqual(array.first(3), 3)
        
        class A
        {
            init() {
                
            }
        }
        
        class B:A {}
        class C:A {}
        class D:A {}
        
        let classes = [A(), A(), C(), C(), B(), A()]
        
        let b: B? = classes.first()
        
        XCTAssertNotNil(b)
        
        let d: D? = classes.first()
        
        XCTAssertNil(d)
        
    }

    func test_min_max()
    {
        let set = Set(arrayLiteral: 1,2,3)
        
        XCTAssertEqual(min(set), 1)
        XCTAssertEqual(max(set), 3)
        
        let array = Array(arrayLiteral: -M_E, 0.2, 1, 0.0001, Double.pi)
        
        XCTAssertEqual(min(array), -M_E)
        XCTAssertEqual(max(array), Double.pi)
        
        XCTAssertEqual(min([1]), 1)
        XCTAssertEqual(max([1]), 1)
        
        let emptyArray: [Int] = []
        
        XCTAssertNil(min(emptyArray))
        XCTAssertNil(max(emptyArray))
        
        func compareLexio(_ lhs: String, rhs: String) -> Bool
        {
            return lhs.compare(rhs, options: NSString.CompareOptions.caseInsensitive) != ComparisonResult.orderedDescending
        }
        
        let strings = Set(arrayLiteral: "sup'", "hello", "hi", "how do you do?")
        
        XCTAssertEqual(max(strings, isOrderedBefore: { $0.count < $1.count }), "how do you do?")
        XCTAssertEqual(min(strings, isOrderedBefore: { $0.count < $1.count }), "hi")
        
        XCTAssertEqual(max(strings, isOrderedBefore: compareLexio), "sup'")
    }
}
