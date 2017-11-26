//
//  ArrayTests.swift
//  Collections
//
//  Created by Christian Otkjær on 07/10/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import XCTest
@testable import Collections

class ArrayTests: XCTestCase
{
    func test_optional_init()
    {
        let s = Array(literalOptionals: 1,2)
        
        XCTAssertEqual(s.count, 2)
        
        let a: Set<Int>? = nil
        
        let A = a?.flatMap({$0})//Array?(optionals: a) as [Int]?
        
        XCTAssertNil(A)

        let b: Set<Int>? = Set<Int>(arrayLiteral: 1,2,3,4)
        
        XCTAssertNotNil(Array(optionals: b))
        
        XCTAssertEqual(Array(optionals: b)?.count, b?.count)
    }
    
    func testChanges()
    {
        let a1 = ["a", "b", "c", "d"]
        let a2 = ["c", "f", "b", "e"]
    
        let deleted = a1.missingIndicies(a2)

        XCTAssertEqual(deleted, [0,3])

        let inserted = a2.missingIndicies(a1)
        
        XCTAssertEqual(inserted, [1,3])
    }
    

    func test_search()
    {
        let array = Array(arrayLiteral: 1,2,3,4,4,4,5,6,7,7,7,8,10)
        
        if let (index, number) = array.search( { $0 > 4 } )
        {
            XCTAssertEqual(number, 5)
            XCTAssertEqual(index, 6)
        }
        else
        {
            XCTFail("nothing found")
        }
        
        if let (index, number) = array.search( { $0 > 7 } )
        {
            XCTAssertEqual(number, 8)
            XCTAssertEqual(index, 11)
        }
        else
        {
            XCTFail("nothing found")
        }
        
        if let (index, number) = array.search( { $0 > 0 } )
        {
            XCTAssertEqual(number, 1)
            XCTAssertEqual(index, 0)
        }
        else
        {
            XCTFail("nothing found")
        }
        
        if let (index, number) = array.search( { $0 > 10 } )
        {
            XCTFail("found index \(index), element: \(number)")
        }
    }
    
    func test_last_where()
    {
        let array = Array(arrayLiteral: 1,2,3,4,4,4,5,6,7,7,7,8,10)
        
        if let (index, number) = array.last(where: { $0 < 5 } )
        {
            XCTAssertEqual(number, 4)
            XCTAssertEqual(index, 5)
        }
        else
        {
            XCTFail("nothing found")
        }

        if let (index, number) = array.last(where: { $0 < 10 } )
        {
            XCTAssertEqual(number, 8)
            XCTAssertEqual(index, 11)
        }
        else
        {
            XCTFail("nothing found")
        }

        if let (index, number) = array.last(where: { $0 < 100 } )
        {
            XCTAssertEqual(number, 10)
            XCTAssertEqual(index, 12)
        }
        else
        {
            XCTFail("nothing found")
        }

        if let (index, number) = array.last(where: { $0 < 1 } )
        {
            XCTFail("found index \(index), element: \(number)")
        }
    }
    
    func test_get()
    {
        var array = Array(arrayLiteral: 1,2,3,4)
        
        XCTAssertNil(array.get(nil))
        XCTAssertNil(array.get(-1))
        XCTAssertNil(array.get(4))
        XCTAssertNil(array.get(10000))
        
        XCTAssertEqual(array.get(3), 4)
        array.removeFirst()
        XCTAssertNil(array.get(3))
        
        array.append(5)
        XCTAssertEqual(array.get(3), 5)
    }
    
    func test_optional_append_prepend_insert()
    {
        var array = Array(arrayLiteral: 2)
        
        XCTAssertNil(array.append(nil))
        XCTAssertEqual(array.append(4), 4)
        XCTAssertEqual(array.prepend(1), 1)
        XCTAssertEqual(array,[1,2,4])
        
        XCTAssertEqual(array.insert(3, at: 2), 3)
        XCTAssertEqual(array,[1,2,3,4])
    }
    
}
