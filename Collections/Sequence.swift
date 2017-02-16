//
//  SequenceType.swift
//  Collections
//
//  Created by Christian Otkjær on 16/09/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

// MARK: - Min & max

public func max<S : Sequence>(_ sequence: S, isOrderedBefore: (S.Iterator.Element, S.Iterator.Element) throws -> Bool) rethrows -> S.Iterator.Element?
{
    return try sequence.max(by: isOrderedBefore)
}

public func max<S : Sequence>(_ sequence: S) -> S.Iterator.Element? where S.Iterator.Element:Comparable
{
    return sequence.max()
}

public func min<S : Sequence>(_ sequence: S) -> S.Iterator.Element? where S.Iterator.Element:Comparable
{
    return sequence.min()
    
    //    return sequence.reduce(nil, combine: { $0 == nil ? $1 : $0 < $1 ? $0 : $1 })
}

public func min<S : Sequence>(_ sequence: S, isOrderedBefore: (S.Iterator.Element, S.Iterator.Element) throws -> Bool) rethrows -> S.Iterator.Element?
{
    return try sequence.min(by: isOrderedBefore)
}

// MARK: - Cycle

public extension Sequence
{
    /**
     Calls the passed block for each element in the sequence, either n times or infinitely, if n isn't specified
     
     - parameter n: the number of times to cycle through
     - parameter block: the block to run for each element in each cycle
     */
    func cycle(_ n: Int? = nil, block: (Iterator.Element) -> ())
    {
        if let n = n
        {
            for _ in stride(from: 0, to: n, by: 1)
            {
                forEach(block)
            }
        }
        else
        {
            while true { forEach(block) }
        }
    }
}

public extension Sequence
{
    ///Return true iff **any** of the elements in self satisfies `predicate`
    
    func any(predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Bool
    {
        return try contains(where: predicate)
    }
    
    ///Return true iff **none** of the elements in self satisfies `predicate`
    
    func none(predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Bool
    {
        return try any{ try !predicate($0) }
    }
    
    ///Return true iff **all** the elements in self satisfies `predicate`
    
    func all(predicate: (Iterator.Element) throws -> Bool) rethrows -> Bool
    {
        return try !any{ try !predicate($0) }
    }
    
    
    /**
     Opposite of filter.
     
     - parameter exclude: Function invoked to test elements for the exclusion from the array
     - returns: self filtered
     */
    func reject(excludeElement: (Self.Iterator.Element) throws -> Bool) rethrows -> [Self.Iterator.Element]
    {
        return try filter { return try !excludeElement($0) }
    }
    
    /**
     Creates a set with an optional entry for every element in this sequence. 
     
     - note: Calls `transform` in the same order as a *for-in loop* would. The returned non-nil results are accumulated to the resulting set
     
     - Parameter transform: closure to apply to elements in the array
     - Returns: the set compiled from the results of calling *transform* on each element in array
     */
    func mapToSet<E:Hashable>(_ transform: (Iterator.Element) -> E?) -> Set<E>
    {
        return Set(flatMap(transform))
    }
    
    /**
     Creates a dictionary with an optional entry for every element in this sequence.
     
     - Note: Different calls to *transform* may yield the same *result-key*, the later call overwrites the value in the dictionary with its own *result-value*
     
     - Parameter transform: closure to apply to the elements in the sequence
     - Returns: the dictionary compiled from the results of calling *transform* on each element in array
     */
    func mapToDictionary<K:Hashable, V>(_ transform: (Iterator.Element) -> (K, V)?) -> Dictionary<K, V>
    {
        var d = Dictionary<K, V>()
        
        forEach { (e) in
            if let (k, v) = transform(e) { d[k] = v }
        }
        
        return d
    }
    
    /**
     counts the elements accepted by `predicate`
     
     - parameter predicate: only elements that are accepted, ie. where the predicate returns *true* when applied to the element are counted
     
     - returns: the number of elements accepted by `predicate`
     */
    func count(_ predicate: (Iterator.Element) throws -> Bool) rethrows -> Int
    {
        return try filter(predicate).count
    }
    
    /**
     Iterates on each element of the sequence.
     
     - parameter closure: invoked for each element in `for in` order
     
     Iterations continues until the closure returns **false**
     */
    func iterate(_ closure: ((_ element: Iterator.Element) -> Bool))
    {
        for element in self
        {
            if closure(element) { break }
        }
    }
    
    /**
     Finds and returns the first element of the specified type (cast as that type).
     
     - returns: First element to match the type or nil, if none did
     */
    func first<T>() -> T?
    {
        return first(where: {$0 is T}) as? T
    }
    
    /// Return an `Array` contisting of the members of `self`, that are `T`s
    
    func cast<T>(_ type: T.Type) -> Array<T>
    {
        return flatMap { $0 as? T }
    }
}

// MARK: - Iterate

public extension Sequence
{
    /**
     Iterates on each element of the sequence.
     
     - parameter closure: Function to call for each index x element, setting the stop parameter to true will stop the iteration
     */
    public func iterate(_ closure: ((_ index: Int, _ element: Iterator.Element, _ stop: inout Bool) -> ()))
    {
        var stop : Bool = false
        
        for (index, element) in enumerated()
        {
            closure(index, element, &stop)
            
            if stop { break }
        }
    }
    
    /**
     Iterates on each element of the array with its index.
     
     - parameter call: Function to call for each element
     */
    public func iterate(_ closure: ((_ element: Iterator.Element, _ stop: inout Bool) -> ()))
    {
        var stop : Bool = false
        
        for element in self
        {
            closure(element, &stop)
            
            if stop { break }
        }
    }
}

public extension Sequence where Iterator.Element: Hashable
{
    var uniques: [Iterator.Element]
    {
        var added = Set<Iterator.Element>()
        
        return filter {
            if added.contains($0) { return false }
            else { added.insert($0); return true }
        }
    }
    
    /**
     Checks whether this sequence shares any elements with `sequence`
     
     - parameter sequence: optional sequence of the same type of elements
     
     - returns: **true** if the two sequences share any elements
     */
    
    func intersects<S : Sequence>(_ sequence: S?) -> Bool where S.Iterator.Element == Iterator.Element
    {
        return sequence?.contains(where: { contains($0) }) ?? false
    }
}

extension Sequence where Iterator.Element == String
{
    public func joinedWithSeparator(_ separator: String, prefix: String, suffix: String) -> String
    {
        return map{ prefix + $0 + suffix }.joined(separator: separator)
    }
}

extension Sequence where Iterator.Element : CustomDebugStringConvertible
{
    public func debugDescription(_ separator: String, prefix: String, suffix: String = "") -> String
    {
        return map{ prefix + $0.debugDescription + suffix }.joined(separator: separator)
    }
    
    //    @warn_unused_result
    //    func joinWithSeparator(separator: String, prefix: String, suffix: String) -> String
    //    {
    //        return map{ prefix + $0 + suffix }.joinWithSeparator(separator)
    //    }
}

extension Sequence where Iterator.Element: Comparable
{
    public func span() -> (Iterator.Element, Iterator.Element)?
    {
        if let mi = self.min(), let ma = self.max()
        {
            return (mi, ma)
        }
        
        return nil
    }
}

extension Sequence where Iterator.Element: Hashable
{
    public func frequencies() -> [(element: Iterator.Element, frequency: Int)]
    {
        var frequency =  Dictionary<Iterator.Element,Int>()
        
        forEach { frequency[$0] = (frequency[$0] ?? 0) + 1 }
        
        return frequency.map{($0.0, $0.1)}.sorted{ $0.1 > $1.1 }
    }
}
