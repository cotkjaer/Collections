//
//  DictionaryTests.swift
//  Collections
//
//  Created by Christian Otkjær on 26/05/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import XCTest

class DictionaryTests: XCTestCase
{

    func test_inits()
    {
        var d = Dictionary([(1, "A"), (2, "B")])
        
        XCTAssertEqual(d.count, 2)
        
        d = Dictionary([(1, "A"), (2, "B"), (2, "C")])
        
        XCTAssertEqual(d.count, 2)
    }
    
    func test_mapPairs()
    {
        let d = Dictionary([(1, "A"),(2, "BB")])
        
        let fi = d.mapPairs { (i, s) -> (Float, Int) in
            (Float(i), s.characters.count)
        }
        
        XCTAssertEqual(fi.count, 2)
        XCTAssertEqual(fi[Float(1)], 1)
        XCTAssertEqual(fi[Float(2)], 2)
        
        let si = d.mapPairs { ($1, $0) }
        
        XCTAssertEqual(si.count, 2)
        XCTAssertEqual(si["BB"], 2)
        XCTAssertEqual(si["CCC"], nil)
    }

    func test_filterPairs()
    {
        let d = Dictionary([(1, "A"),(2, "BB"), (3, "CCC")])
        
        XCTAssertEqual(d.filterPairs{$0.key > 2}.count, 1)
        XCTAssertEqual(d.filterPairs{$0.value < "C"}.count, 2)
    }
    
    func test_map()
    {
        let d = Dictionary([(1, "A"),(2, "BB"), (3, "CCC")])
        
        let i = d.map {$0.characters.count}
        
        XCTAssertEqual(i.count, 3)
        XCTAssertEqual(i[2], 2)
    }

    func test_flatMap()
    {
        let d = Dictionary([(1, "A"),(2, "BB"), (3, "CCC")])

        XCTAssertEqual(d.count, 3)
        XCTAssertNotNil(d[3])

        let i = d.flatMap { $0.characters.count > 2 ? nil : $0 }
        
        XCTAssertEqual(i.count, 2)
        XCTAssertNil(i[3])
    }
}
