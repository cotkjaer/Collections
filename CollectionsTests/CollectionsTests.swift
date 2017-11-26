//
//  CollectionsTests.swift
//  CollectionsTests
//
//  Created by Christian Otkjær on 16/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import XCTest
@testable import Collections

class CollectionsTests: XCTestCase
{
    func test_first()
    {
        let array = [1,2,3,4,5,6,7,9,1,2,1,2,1,1]
        
        XCTAssertEqual(array.first{ $0 > 7 }, 9)
        
        let b: Array<Any> = [Int(1), Double(2), Float(3), Float(1), [4,4]]
        
        let f: Float? = b.first()
        
        XCTAssertNotNil(f)
        XCTAssertEqual(f, Float(3))
    }
    
    
    
    func test_Queue()
    {
        var queue = Array<Int>()

        XCTAssertNil(queue.dequeue())

        queue.enqueue(1)
        
        XCTAssertEqual(queue.dequeue(), 1)
        XCTAssertNil(queue.dequeue())

        queue.enqueue(1)
        queue.enqueue(2)

        XCTAssertEqual(queue.count, 2)

        XCTAssertEqual(queue.dequeue(), 1)
        XCTAssertEqual(queue.dequeue(), 2)
        XCTAssertNil(queue.dequeue())

        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        
        XCTAssertEqual(queue.count, 3)
        XCTAssertEqual(queue.dequeue(), 1)
        
        queue.enqueue(1)
        
        XCTAssertEqual(queue.dequeue(), 2)
        XCTAssertEqual(queue.dequeue(), 3)
        XCTAssertEqual(queue.dequeue(), 1)
        XCTAssertNil(queue.dequeue())
    }
}
