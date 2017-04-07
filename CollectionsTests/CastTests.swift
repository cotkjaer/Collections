//
//  CastTests.swift
//  Collections
//
//  Created by Christian Otkjær on 07/04/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import XCTest

@testable import Collections

class CastTests: XCTestCase
{
    func test_cast()
    {
        let setA = Set<A>(A(), B(), C())
        
        XCTAssertEqual(setA.count, 3)
        
        let setB: Set<B> = setA.cast()

        XCTAssertEqual(setB.count, 1)

        let arrayA = Array<A>(arrayLiteral: A(), A(), B(), C(), B())
        
        XCTAssertEqual(arrayA.count, 5)
        
        let arrayB: Array<B> = arrayA.cast()
        
        XCTAssertEqual(arrayB.count, 2)

        let arrayC: Array<C> = setA.cast()
        
        XCTAssertEqual(arrayC, [C()])
    }
}
