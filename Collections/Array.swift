//
//  Array.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 05/05/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

//MARK: - Functional Inits

public extension Array
{
    /// Init with elements produced by calling `block` `count` times.
    init(count: Int, @noescape block: Int -> Element)
    {
        self.init()
        
        for i in 0..<count
        {
            append(block(i))
        }
    }
    
    /// Init with elements produced by calling `block` until it returns `nil`.
    /// -warning: Calls `block` until it returns nil
    init(@noescape block: () -> Element?)
    {
        self.init()
        
        while let e = block()
        {
            append(e)
        }
    }
}


public extension Array
{
    /**
     Creates a dictionary with an optional entry for every element in the array.
     
     - Note: Different calls to *transform* may yield the same *result-key*, the later call overwrites the value in the dictionary with its own *result-value*
     
     - Parameter transform: closure to apply to the elements in the array
     - Returns: the dictionary compiled from the results of calling *transform* on each element in array
     */
    func mapToDictionary<K:Hashable, V>(@noescape transform: (Element) -> (K, V)?) -> Dictionary<K, V>
    {
        return flatMap(transform).reduce([:]) { (var dictionary, element) in
            dictionary[element.0] = element.1
            return dictionary
        }
        
        //        return reduce([:]) {
        //            (var dictionary, element) in
        //            if let (key, value) = transform(element)
        //            {
        //                dictionary[key] = value
        //            }
        //            return dictionary
        //        }
    }
}


// MARK: - Take

public extension Array
{
    /// Removes the first element to match `predicate` from the array and returns the found element
    @warn_unused_result
    mutating func take(@noescape predicate: (Element throws -> Bool) = { $0 != nil }) rethrows -> Element?
    {
        if let index = try indexOf(predicate)
        {
            let element = self[index]
            
            removeAtIndex(index)
            
            return element
        }
        
        return nil
    }
    
    /**
     Returns an array containing the first n elements of self.
     
     - parameter n: Number of elements to take
     - returns: First n elements
     */
    func take(n: Int) -> Array
    {
        return Array(self[0..<max(0, n)])
    }
    
    /**
     Returns the elements of the array up until an element does not meet the condition.
     
     - parameter condition: A function which returns a boolean if an element satisfies a given condition or not.
     - returns: Elements of the array up until an element does not meet the condition
     */
    func takeWhile(condition: Element -> Bool) -> Array
    {
        var lastTrue = -1
        
        for (index, value) in self.enumerate()
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
     - parameter predicate:
     
     - returns: subarray
     */
    func upTill(include include: Bool = true, @noescape _ predicate: (Element -> Bool)) -> Array<Element>
    {
        if let index = indexOf(predicate)
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
     - parameter predicate:
     
     - returns: subarray
     */
    @warn_unused_result
    func stopFilter(include include: Bool = true, target: Bool = true, @noescape _ predicate: Element -> Bool) -> Array<Element>
    {
        if let index = indexOf({ predicate($0) == target })
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
     Runs a binary search to find the **last** element for which the predicate evaluates to `true`.
     
     The predicate should return `true` for all elements in the array below a certain index and `false` for all elements above that index
     
     - parameter predicate: the predicate to test elements
     - returns: The found index and element, or `nil` if there are no elements in the array for which the predicate returns `true`
     */
    @warn_unused_result
    public func lastWhere(@noescape predicate: Element -> Bool) -> (Int, Element)?
    {
        guard count > 0 else { return nil }
        
        var low = 0
        var high = count - 1
        
        while low <= high
        {
            let mid = (high + low) / 2
            
            if predicate(self[mid])
            {
                if mid == high || !predicate(self[mid + 1])
                {
                    return (mid, self[mid])
                }
                else
                {
                    low = mid + 1
                }
            }
            else
            {
                high = mid - 1
            }
        }
        
        return nil
    }
    
    
    /**
     Runs a binary search to find the first element for which the predicate evaluates to **true**
     The predicate should return **false** for all elements in the array below a certain index and **true** for all elements above that index
     If that index is beyond the last index in the array, nil is returned
     
     - parameter predicate: the predicate to test elements
     - returns: the first index and element at that index, or nil if there are no elements for which the predicate returns true
     */
    @warn_unused_result
    public func firstWhere(@noescape predicate: Element -> Bool) -> (Int, Element)?
    {
        if count == 0
        {
            return nil
        }
        
        var low = 0
        var high = count - 1
        while low <= high
        {
            let mid = low + (high - low) / 2
            
            if predicate(self[mid])
            {
                if mid == 0 || !predicate(self[mid - 1])
                {
                    return (mid, self[mid])
                }
                else
                {
                    high = mid
                }
            }
            else
            {
                low = mid + 1
            }
        }
        
        return nil
    }
    
    /**
     Runs a binary search to find the smallest element for which the predicate evaluates to true
     The predicate should return true for all elements in the array above a certain index and false for all elements below a certain index
     If that index is beyond the last index in the array, it returns nil
     
     - parameter predicate: the predicate to test each element
     - returns: the min index and element at that index, or nil if there are no elements for which the predicate returns true
     */
    public func bSearch(predicate: Element -> Bool) -> (Int, Element)?
    {
        if count == 0
        {
            return nil
        }
        
        var low = 0
        var high = count - 1
        while low <= high
        {
            let mid = low + (high - low) / 2
            
            if predicate(self[mid])
            {
                if mid == 0 || !predicate(self[mid - 1])
                {
                    return (mid, self[mid])
                }
                else
                {
                    high = mid
                }
            }
            else
            {
                low = mid + 1
            }
        }
        
        return nil
    }
    
    /**
     Runs a binary search to find some element for which the block returns 0.
     The block should return a negative number if the current value is before the target in the array, 0 if it's the target, and a positive number if it's after the target
     The Spaceship operator is a perfect fit for this operation, e.g. if you want to find the object with a specific date and name property, you could keep the array sorted by date first, then name, and use this call:
     let match = bSearch
     {
     [targetDate, targetName] <=> [$0.date, $0.name] }
     
     See http://ruby-doc.org/core-2.2.0/Array.html#method-i-bsearch regarding find-any mode for more
     
     - parameter block: the block to run each time
     - returns: an item (there could be multiple matches) for which the block returns true
     */
    func bSearch (block: (Element) -> (Int)) -> Element?
    {
        let match = bSearch
            {
                item in
                block(item) >= 0
        }
        if let (_, element) = match
        {
            return block(element) == 0 ? element : nil
        }
        else
        {
            return nil
        }
    }
}


// MARK: List , Queue and Stack operations
public extension Array
{
    /**
     Treats the array as a Stack; removing the last element of the array and returning it.
     
     - returns: The removed element, or nil if the array is empty
     */
    mutating func pop() -> Element?
    {
        return isEmpty ? nil : removeLast()
    }
    
    /**
     Treats the array as a Stack or Queue; appending the list of elements to the end of the array.
     
     - parameter elements: The elements to append
     */
    mutating func push(elements: Element...)
    {
        switch elements.count
        {
        case 0: return
            
        case 1: self.append(elements[0])
            
        default: self += elements
        }
    }
    
    /**
     Treats the array as a Queue; removing the first element in the array and returning it.
     
     - returns: The removed element, or nil if the array is empty
     */
    mutating func shift() -> Element?
    {
        return isEmpty ? nil : removeFirst()
    }
    
    /**
     Prepends a list of elements to the front of the array. The elements are prepended as a list, **not** one at a time. Thus the order in the list is preserved in the array
     
     - parameter elements: The elements to prepend
     */
    mutating func unshift(elements: Element...)
    {
        switch elements.count
        {
        case 0: return
            
        case 1: self.insert(elements[0], atIndex: 0)
            
        default: self = elements + self
        }
    }
}

// MARK: - Changes

public extension Array where Element : Equatable
{
    func missingIndicies(otherArray: Array<Element>) -> [Index]
    {
        return enumerate().filter{!otherArray.contains($0.element)}.map{$0.index}
    }
}

/**
Add a optional array
*/
infix operator ?+ { associativity left precedence 130 }

public func ?+ <T> (first: [T], optionalSecond: [T]?) -> [T]
{
    if let second = optionalSecond
    {
        return first + second
    }
    else
    {
        return first
    }
}

infix operator ?+= { associativity right precedence 90 }

public func ?+= <T> (inout left: [T], optionalRight: [T]?)
{
    if let right = optionalRight
    {
        left += right
    }
}

/**
 Remove an element from the array
 */
public func - <T: Equatable> (first: [T], second: T) -> [T]
{
    return first - [second]
}

/**
 Difference operator
 */
public func - <T: Equatable> (first: [T], second: [T]) -> [T]
{
    return first.filter { !second.contains($0) }
}

/**
 Intersection operator
 */
public func & <T: Equatable> (first: [T], second: [T]) -> [T]
{
    return first.filter { second.contains($0) }
}

/**
 Union operator
 */
public func | <T: Equatable> (first: [T], second: [T]) -> [T]
{
    return first + (second - first)
}