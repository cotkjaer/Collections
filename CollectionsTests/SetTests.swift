//
//  SetTests.swift
//  Collections
//
//  Created by Christian Otkjær on 18/09/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import XCTest

@testable import Collections

//MARK: - Hashable

class A : Hashable
{
    var hashValue : Int { return 1 }
}

class B: A { override var hashValue : Int { return 2 } }

class C: A { override var hashValue : Int { return 3 } }


func == (lhs: A, rhs:A) -> Bool
{
    return lhs.hashValue == rhs.hashValue
}

class SetTests: XCTestCase
{
    let set0 = Set<Int>()
    let set1 = Set(1)
    let set23 = Set(2, 3)
    let set123 = Set("1", "2", nil, "3", "1")
    
    func testListInit()
    {
        let setset = Set(set0, set1, set23, nil)
        
        XCTAssertEqual(set1.count, 1)
        XCTAssertEqual(set23.count, 2)
        XCTAssertEqual(set123.count, 3)
        XCTAssertEqual(setset.count, 3)
    }
    
    func testMap()
    {
        let setABC = Set<A>(A(), B(), A(), C(), nil, C())
        let setBC = Set<A>(B(), C(), B(), C(), B(), C(), B(), C(), B(), C(), nil, C())
        
        XCTAssertEqual(setABC.count, 3)
        XCTAssertEqual(setBC.count, 2)
        
        XCTAssert(type(of: setABC) == Set<A>.self)
        
        XCTAssert(type(of: setABC) == type(of: setBC))
        
        let mapped = setABC.map { $0 as? C }
        
        XCTAssert(type(of: mapped) == Set<C>.self)
        
        XCTAssertEqual(mapped.count, 1)
        
        XCTAssertEqual(setABC.map{ if type(of: $0) == A.self { return nil } ; return $0 }, setBC)
    }
    
    func testSift()
    {
        let setABC = Set<A>(A(), B(), A(), C(), nil, C())
        let setBC = Set<A>(B(), C(), B(), C(), B(), C(), B(), C(), B(), C(), nil, C())
        
        let filteredForC = setABC.sift {$0 is C}
        
        XCTAssert(type(of: filteredForC) == Set<A>.self)
        
        XCTAssert(type(of: filteredForC) == type(of: setABC))
        
        XCTAssertEqual(filteredForC, setBC.sift { $0 is C })
        XCTAssertEqual(setBC.filter({ $0.hashValue == 1 }).count, 0)
    }
    
    func testUnion()
    {
        var noSet : Set<Int>? = Set()
        
        XCTAssertEqual(set1.union(set23), Set(1,2,3))
        XCTAssertEqual(set23.union(set0), set23)
        XCTAssertEqual(set23.union(noSet), set23)
        
        var set = Set<Int>()
        
        set.formUnion(noSet)
        
        XCTAssertEqual(set, Set())
        
        set.formUnion(set23)
        
        XCTAssertEqual(set, set23)
        
        set.formUnion(noSet)
        
        XCTAssertEqual(set, set23)
        
        noSet = nil
        
        set.formUnion(noSet)
        
        XCTAssertEqual(set, set23)
        
        XCTAssertEqual(set23.union(noSet), set23)
        
        noSet = Set(4)
        
        set.formUnion(noSet)
        
        XCTAssertEqual(set, Set(2,3,4))
        
        XCTAssertEqual(set23.union(noSet), Set(2,3,4))
    }
    
    func testSubsets()
    {
        let set1 = Set(1)
        let set2 = Set(2)
        let set3 = Set(3)
        
        let set12 = Set(1,2)
        let set13 = Set(1,3)
        let set23 = Set(2,3)
        
        let set123 = Set(1,2,3)
        
        let expectedSubsets = Set(set1, set2, set3, set12, set13, set23)
        
        XCTAssertEqual(set123.subsets().count, 6)

        XCTAssertEqual(set123.subsets(), expectedSubsets)
        
        XCTAssertEqual(set12.subsets().count, 2)
        
        XCTAssertEqual(set12.subsets(), Set(set1, set2))
    }
    
    func test_operators()
    {
        var s = Set(1,2,3,4)
        let a = Array(arrayLiteral: 2,3)
        
        XCTAssertEqual(s - s, Set<Int>())
        XCTAssertEqual(s - a, Set(1,4))
        
        s -= Set(5,6,7)
        
        XCTAssertEqual(s, Set(1,2,3,4))
        
        s += Set(4,5,6,7)

        XCTAssertEqual(s, Set(1,2,3,4,5,6,7))

        s += a

        XCTAssertEqual(s, Set(1,2,3,4,5,6,7))

        s -= a
        
        XCTAssertEqual(s, Set(1,4,5,6,7))

        XCTAssertEqual(s + 2, Set(1,2,4,5,6,7))

        XCTAssertEqual(s + 1, Set(1,4,5,6,7))

        s += 1
        
        XCTAssertEqual(s, Set(1,4,5,6,7))

        s += 2
        
        XCTAssertEqual(s, Set(1,2,4,5,6,7))
        
        s = Set(3,4) + Set(a) + Set(1)
        
        XCTAssertEqual(s, Set(1,2,3,4))
        
    }
}
