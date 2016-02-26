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
    func test_Queue()
    {
        let queue = Queue<Int>()

        XCTAssertNil(queue.dequeue())

        queue.enqueue(1)
        
        XCTAssertEqual(queue.dequeue(), 1)
        XCTAssertNil(queue.dequeue())

        queue.enqueue(1)
        queue.enqueue(2)
        
        XCTAssertEqual(queue.dequeue(), 1)
        XCTAssertEqual(queue.dequeue(), 2)
        XCTAssertNil(queue.dequeue())

        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        
        XCTAssertEqual(queue.dequeue(), 1)
        
        queue.enqueue(1)
        
        XCTAssertEqual(queue.dequeue(), 2)
        XCTAssertEqual(queue.dequeue(), 3)
        XCTAssertEqual(queue.dequeue(), 1)
        XCTAssertNil(queue.dequeue())
    }
}
