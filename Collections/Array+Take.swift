//
//  Array+Take.swift
//  Collections
//
//  Created by Christian Otkjær on 06/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - Take

public extension Array
{
    /// Removes the first element to match `predicate` from the array and returns the found element
    
    mutating func take(predicate: ((Element) throws -> Bool) = { _ in return true }) rethrows -> Element?
    {
        guard let index = try index(where: predicate) else { return nil }
        
        let element = self[index]
        
        remove(at: index)
        
        return element
    }
    
    /**
     Returns an array containing the first n elements of self.
     
     - parameter n: Number of elements to take
     - returns: First n elements
     */
    func take(_ n: Int) -> Array
    {
        return Array(self[0..<Swift.max(0, n)])
    }
    
    /**
     Returns the elements of the array up until an element does not meet the condition.
     
     - parameter condition: A function which returns a boolean if an element satisfies a given condition or not.
     - returns: Elements of the array up until an element does not meet the condition
     */
    func takeWhile(_ condition: (Element) -> Bool) -> Array<Element>
    {
        var lastTrue = -1
        
        for (index, value) in self.enumerated()
        {
            if condition(value)
            {
                lastTrue = index
            }
            else
            {
                break
            }
        }
        
        return take(lastTrue + 1)
    }
    
    /**
     Generates an array with all elements up till predicate evaluates true
     
     - parameter include: if **true** the element that makes the predicate ture is included as the last element in the generated array
     - parameter predicate: the predicate
     
     - returns: subarray
     */
    func upTill(include: Bool = true, predicate: ((Element) -> Bool)) -> Array<Element>
    {
        if let index = index(where: predicate)
        {
            if include
            {
                return Array(self[0...index])
            }
            else if index > 0
            {
                return Array(self[0..<index])
            }
            else
            {
                return[]
            }
        }
        
        return self
    }
    
    /**
     Generates an array with all elements up till predicate evaluates to a given target
     - parameter include: if **true** the element that makes the predicate hit the target is included as the last element in the generated array, default **true**
     - parameter target: the target value for the predicate, default **true**
     - parameter predicate: the predicate
     - returns: subarray
     */
    
    func stopFilter(include: Bool = true, target: Bool = true, _ predicate: (Element) -> Bool) -> Array<Element>
    {
        if let index = index(where: { predicate($0) == target })
        {
            if include
            {
                return Array(self[0...index])
            }
            else if index > 0
            {
                return Array(self[0..<index])
            }
            else
            {
                return[]
            }
        }
        
        return self
    }
}
