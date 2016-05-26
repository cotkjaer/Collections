//
//  HeapTests.swift
//  Collections
//
//  Created by Christian Otkjær on 26/05/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import XCTest

@testable import Collections

class HeapTests: XCTestCase
{
    func elements() -> Array<(Int, Float)>
    {
        return 0.stride(to: 1000, by: 1).map({(random(), Float($0))})
    }
    
    func test_init_heap()
    {
        let _ = Heap<Bool>(isOrderedBefore: { $0 ? !$1 : $1 })
        let _ = Heap<Int>()
        let _ = Heap<String>()
        let _ = Heap<(Int, Float)>(isOrderedBefore: {$0.0 < $1.0})
        
        let _ = Heap(elements: self.elements(), isOrderedBefore: {$0.0 < $1.0})
        let _ = Heap(elements: [0,2,1,5,9])
    }
    
    func test_push_and_peek()
    {
        var heap = Heap<Int>()

        XCTAssertEqual(heap.count, 0)

        
        heap.push(3)
        XCTAssertEqual(heap.count, 1)
        XCTAssertEqual(heap.peek(), 3)
        
        heap.push(4)
        
        XCTAssertEqual(heap.count, 2)
        XCTAssertEqual(heap.peek(), 3)
        
        heap.push(1)
        
        XCTAssertEqual(heap.count, 3)
        XCTAssertEqual(heap.peek(), 1)
    }

    func test_push_performance()
    {
        var heap = Heap<(Int, Float)>(isOrderedBefore: {$0.0 < $1.0})
        
        let elements = self.elements()
        
        var counter = 0
        measureBlock
            {
                counter += 1
                for e in elements
                {
                    heap.push(e)
                }
        }
        
        XCTAssertEqual(heap.count, elements.count * counter)
    }

    func test_heap_pop_performance()
    {
        var heap = Heap<(Int, Float)>(isOrderedBefore: {$0.0 < $1.0})

        for e in elements()
        {
            heap.push(e)
        }

        measureBlock
            {
                while !heap.isEmpty
                {
                    let _ = heap.pop()
                }
        }
    }

    func test_heap_pop()
    {
        var heap = Heap<Int>()
        
        for e in elements()
        {
            heap.push(e.0)
        }

        var top = heap.pop()
        
        XCTAssertNotNil(top)
        
        while let nextTop = heap.pop()
        {
            print(top!)
            XCTAssertLessThanOrEqual(top!, nextTop)
            top = nextTop
        }
    }
}
