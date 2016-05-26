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
    }

    func test_heap_push_performance()
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
