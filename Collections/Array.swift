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
    /// Init with elements produced by calling `closure` `count` times.
    /// - parameter closure : The factory code, gets invoked with integers from `0..<count`
    /// - parameter count : number of times to invoke the factory code
    public init(repeating closure: (Int) -> Element, count: Int)
    {
        self = (0..<count).map(closure)
    }
    
    /// Init with elements produced by calling `closure` `count` times.
    /// - parameter closure : The factory code
    /// - parameter count : number of times to invoke the factory code
    public init(repeating closure: () -> Element, count: Int)
    {
        self = (0..<count).map { _ in closure() }
    }
    
    /// Init with elements produced by calling `closure` `count` times.
    @available(*, deprecated) init(count: Int, closure: (Int) -> Element)
    {
        self.init()
        
        for i in 0..<count
        {
            append(closure(i))
        }
    }
    
    /// Init with elements produced by calling `closure` until it returns `nil`.
    /// - warning: Calls `closure` until it returns nil, if closure never does, the code hangs
    init(closure: () -> Element?)
    {
        self.init()
        
        while let e = closure()
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
    func mapToDictionary<K:Hashable, V>(_ transform: (Element) -> (K, V)?) -> Dictionary<K, V>
    {
        var d = Dictionary<K, V>()
        
        forEach { (e) in
            if let (k, v) = transform(e) { d[k] = v }
        }
        
        return d
    }
}


// MARK: - Take

public extension Array
{
    /// Removes the first element to match `predicate` from the array and returns the found element
    
    mutating func take(predicate: ((Element) throws -> Bool) = { _ in return true }) rethrows -> Element?
    {
        if let index = try index(where: predicate)
        {
            let element = self[index]
            
            remove(at: index)
            
            return element
        }
        
        return nil
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
    func takeWhile(_ condition: (Element) -> Bool) -> Array
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
     - parameter predicate:
     
     - returns: subarray
     */
    func upTill(include: Bool = true, _ predicate: ((Element) -> Bool)) -> Array<Element>
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
     - parameter predicate:
     
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
    
    
    /**
     Runs a binary search to find the **last** element for which the predicate evaluates to `true`.
     
     The predicate should return `true` for all elements in the array below a certain index and `false` for all elements above that index
     
     - parameter predicate: the predicate to test elements
     - returns: The found index and element, or `nil` if there are no elements in the array for which the predicate returns `true`
     */
    
    public func lastWhere(_ predicate: (Element) -> Bool) -> (Int, Element)?
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
    
    public func firstWhere(_ predicate: (Element) -> Bool) -> (Int, Element)?
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
    public func bSearch(_ predicate: (Element) -> Bool) -> (Int, Element)?
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
     Runs a binary search to find some element for which the closure returns 0.
     The closure should return a negative number if the current value is before the target in the array, 0 if it's the target, and a positive number if it's after the target
     The Spaceship operator is a perfect fit for this operation, e.g. if you want to find the object with a specific date and name property, you could keep the array sorted by date first, then name, and use this call:
     let match = bSearch
     {
     [targetDate, targetName] <=> [$0.date, $0.name] }
     
     See http://ruby-doc.org/core-2.2.0/Array.html#method-i-bsearch regarding find-any mode for more
     
     - parameter closure: the closure to run each time
     - returns: an item (there could be multiple matches) for which the closure returns true
     */
    func bSearch (_ closure: (Element) -> (Int)) -> Element?
    {
        let match = bSearch
            {
                item in
                closure(item) >= 0
        }
        if let (_, element) = match
        {
            return closure(element) == 0 ? element : nil
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
    mutating func push(_ elements: Element...)
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
    mutating func unshift(_ elements: Element...)
    {
        switch elements.count
        {
        case 0: return
            
        case 1: self.insert(elements[0], at: 0)
            
        default: self = elements + self
        }
    }
}

// MARK: - Changes

public extension Array where Element : Equatable
{
    func missingIndicies(_ otherArray: Array<Element>) -> [Index]
    {
        return enumerated().filter{!otherArray.contains($0.element)}.map{ $0.offset }
    }
}

/**
 Add a optional array
 */
infix operator ?+ : AdditionPrecedence //{ associativity left precedence 130 }

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

infix operator ?+= : AdditionPrecedence // { associativity right precedence 90 }

public func ?+= <T> (left: inout [T], optionalRight: [T]?)
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
