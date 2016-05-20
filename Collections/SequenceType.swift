//
//  SequenceType.swift
//  Collections
//
//  Created by Christian Otkjær on 16/09/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

// MARK: - Min & max

public func max<S : SequenceType>(sequence: S, isOrderedBefore: (S.Generator.Element, S.Generator.Element) throws -> Bool) rethrows -> S.Generator.Element?
{
    return try sequence.maxElement(isOrderedBefore)
}

public func max<S : SequenceType where S.Generator.Element:Comparable>(sequence: S) -> S.Generator.Element?
{
    return sequence.maxElement()
}

public func min<S : SequenceType where S.Generator.Element:Comparable>(sequence: S) -> S.Generator.Element?
{
    return sequence.minElement()

//    return sequence.reduce(nil, combine: { $0 == nil ? $1 : $0 < $1 ? $0 : $1 })
}

public func min<S : SequenceType>(sequence: S, isOrderedBefore: (S.Generator.Element, S.Generator.Element) throws -> Bool) rethrows -> S.Generator.Element?
{
    return try sequence.minElement(isOrderedBefore)
}

// MARK: - Cycle

public extension SequenceType
{
    /**
     Calls the passed block for each element in the sequence, either n times or infinitely, if n isn't specified
     
     - parameter n: the number of times to cycle through
     - parameter block: the block to run for each element in each cycle
     */
    func cycle(n: Int? = nil, @noescape block: Generator.Element -> ())
    {
        if let n = n
        {
            for _ in 0.stride(to: n, by: 1)
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

public extension SequenceType
{
    ///Return true iff **any** of the elements in self satisfies `predicate`
    @warn_unused_result
    func any(@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Bool
    {
        return try contains(predicate)
    }
    
    ///Return true iff **none** of the elements in self satisfies `predicate`
    @warn_unused_result
    func none(@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Bool
    {
        return try any{ try !predicate($0) }
    }
    
    ///Return true iff **all** the elements in self satisfies `predicate`
    @warn_unused_result
    func all(@noescape predicate: (Generator.Element) throws -> Bool) rethrows -> Bool
    {
        return try !any{ try !predicate($0) }
    }
    
    
    /**
     Opposite of filter.
     
     - parameter exclude: Function invoked to test elements for the exclusion from the array
     - returns: self filtered
     */
    @warn_unused_result func reject(@noescape excludeElement: (Self.Generator.Element) throws -> Bool) rethrows -> [Self.Generator.Element]
    {
        return try filter { return try !excludeElement($0) }
    }
    
    /**
     Creates a set with an optional entry for every element in the array. Calls _transform_ in the same sequence as a *for-in loop* would. The returned non-nil results are accumulated to the resulting set
     
     - Parameter transform: closure to apply to elements in the array
     - Returns: the set compiled from the results of calling *transform* on each element in array
     */
    func mapToSet<E:Hashable>(@noescape transform: Generator.Element -> E?) -> Set<E>
    {
        return Set(flatMap(transform))
    }
    
    /**
     counts the elements accepted by `predicate`
     
     - parameter predicate: only elements that are accepted, ie. where the predicate returns *true* when applied to the element are counted
     
     - returns: the number of elements accepted by `predicate`
     */
    func count(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Int
    {
        return try filter(predicate).count
    }
    
    /**
     Iterates on each element of the sequence.
     
     - parameter closure: invoked for each element in `for in` order
     
     Iterations continues until the closure returns **false**
     */
    func iterate(@noescape closure: ((element: Generator.Element) -> Bool))
    {
        for element in self
        {
            if closure(element: element) { break }
        }
    }
    
    /**
     Finds the first element which meets the condition.
     
     - parameter condition: A closure which takes an Element and returns a Bool
     - returns: First element to match contidion or nil, if none matched
     */
    @warn_unused_result
    func find(@noescape condition: Generator.Element -> Bool) -> Generator.Element?
    {
        for element in self
        {
            if condition(element) { return element }
        }
        
        return nil
    }
    
    /**
     Finds and returns the first element of the specified type (cast as that type).
     
     - parameter type: A type to look for
     - returns: First element to match the type or nil, if none did
     */
    @warn_unused_result
    func find<T>(type: T.Type) -> T?
    {
        return find({$0 is T}) as? T
    }
    
    /// Return an `Array` contisting of the members of `self`, that are `T`s
    @warn_unused_result
    func cast<T>(type: T.Type) -> Array<T>
    {
        return flatMap { $0 as? T }
    }
}

// MARK: - Iterate

public extension SequenceType
{
    /**
     Iterates on each element of the array.
     
     - parameter closure: Function to call for each index x element, setting the stop parameter to true will stop the iteration
     */
    public func iterate(closure: ((index: Int, element: Generator.Element, inout stop: Bool) -> ()))
    {
        var stop : Bool = false
        
        for (index, element) in enumerate()
        {
            closure(index: index, element: element, stop: &stop)
            
            if stop { break }
        }
    }
    
    /**
     Iterates on each element of the array with its index.
     
     - parameter call: Function to call for each element
     */
    public func iterate(closure: ((element: Generator.Element, inout stop: Bool) -> ()))
    {
        var stop : Bool = false
        
        for element in self
        {
            closure(element: element, stop: &stop)
            
            if stop { break }
        }
    }
    
}


public extension SequenceType where Generator.Element: Hashable
{
    var uniques: [Generator.Element]
        {
            var added = Set<Generator.Element>()
            
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
    @warn_unused_result
    func intersects<S : SequenceType where S.Generator.Element == Generator.Element>(sequence: S?) -> Bool
    {
        return sequence?.contains({ contains($0) }) ?? false
    }
}

extension SequenceType where Generator.Element == String
{
    @warn_unused_result
    public func joinedWithSeparator(separator: String, prefix: String, suffix: String) -> String
    {
        return map{ prefix + $0 + suffix }.joinWithSeparator(separator)
    }
}

extension SequenceType where Generator.Element : CustomDebugStringConvertible
{
    public func debugDescription(separator: String, prefix: String, suffix: String = "") -> String
    {
        return map{ prefix + $0.debugDescription + suffix }.joinWithSeparator(separator)
    }
    
    //    @warn_unused_result
    //    func joinWithSeparator(separator: String, prefix: String, suffix: String) -> String
    //    {
    //        return map{ prefix + $0 + suffix }.joinWithSeparator(separator)
    //    }
}

extension SequenceType where Generator.Element: Comparable
{
    public func span() -> (Generator.Element, Generator.Element)?
    {
        if let mi = minElement(), let ma = maxElement()
        {
            return (mi, ma)
        }
        
        return nil
    }
}

extension SequenceType where Generator.Element: Hashable
{
    public func frequencies() -> [(element: Generator.Element, frequency: Int)]
    {
        var frequency =  Dictionary<Generator.Element,Int>()
        
        forEach { frequency[$0] = (frequency[$0] ?? 0) + 1 }
        
        return frequency.map{($0.0, $0.1)}.sort{ $0.1 > $1.1 }
    }
}

