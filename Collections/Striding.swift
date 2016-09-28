//
//  Striding.swift
//  Collections
//
//  Created by Christian Otkjær on 18/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

/**
*  Generator that "strides" through a sequence two elements at a time.
*/

struct StrindingPairGenerator<T>: IteratorProtocol
{
    typealias Element = (T, T?)
    
    var arrayGenerator: Array<T>.Iterator
    var arrayElement: T?
    
    init<S: Sequence>(_ s: S) where S.Iterator.Element == T
    {
        arrayGenerator = Array(s).makeIterator()
        arrayElement = arrayGenerator.next()
    }
    
    mutating func next() -> Element?
    {
        guard let arrayElement = arrayElement else { return nil }
        
        let next = arrayGenerator.next()
        let result = (arrayElement, next)
        self.arrayElement = next
        
        return result
    }
}
