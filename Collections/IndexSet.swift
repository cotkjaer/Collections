//
//  NSIndexSet.swift
//  Collections
//
//  Created by Christian Otkjær on 01/10/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import Foundation

//MARK: - OptionalEquality

extension IndexSet
{
    public init<S:Sequence>(indicies: S) where S.Iterator.Element == Int
    {
        self.init()
        
        for i in indicies
        {
            insert(i)
        }
    }
}

extension NSIndexSet
{
    // MARK: - Init
    
    public convenience init<S:Sequence>(indicies: S) where S.Iterator.Element == Int
    {
        let mutable = NSMutableIndexSet()
        
        indicies.forEach { mutable.add($0) }
        
        self.init(indexSet: mutable as IndexSet)
    }
    
    // MARK: - Sets and NSIndexSet
    
    public var indicies : Set<Int>
    {
        var set = Set<Int>()
        
        self.forEach({ set.insert($0) })
        
        return set
    }
}
