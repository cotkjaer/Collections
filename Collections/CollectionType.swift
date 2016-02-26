//
//  CollectionType.swift
//  Collections
//
//  Created by Christian Otkjær on 14/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

// MARK: - Get

public extension CollectionType
{
    /**
     Gets the element at the specified (optional) index, if it exists and is within the collections bounds.
     
     - parameter optionaleIndex: the optional index to look up
     - returns: the element at the index in `self`
     */
    @warn_unused_result
    func get(index: Index?) -> Generator.Element?
    {
        guard let index = index else { return nil }
        
        guard startIndex.distanceTo(index) >= 0 else { return nil }
        
        guard index.distanceTo(endIndex) > 0 else { return nil }
        
        return self[index]
    }
}

// MARK: - Find

public extension CollectionType
{
    /**
     Finds the first element which meets the condition.
     
     - parameter condition: A closure which takes an Element and returns a Bool
     - returns: First element to match contidion or nil, if none matched
     */
    @warn_unused_result
    func find(@noescape condition: Generator.Element throws -> Bool) rethrows -> Generator.Element?
    {
        if let index = try indexOf(condition)
        {
            return self[index]
        }
        
        return nil
        
        //        for element in self
        //        {
        //            if try condition(element) { return element }
        //        }
        //        return nil
    }
}

// MARK: - Optional versions

public extension CollectionType where Generator.Element : Equatable
{
    ///Returns the first index where `optionalElement` appears in `self` or `nil` if `optionalElement` is not found.
    @warn_unused_result
    public func indexOf(optionalElement: Generator.Element?) -> Index?
    {
        if let element = optionalElement
        {
            return indexOf { $0 == element }
        }
        
        return nil
    }
    
    ///Returns the first element that is equal to `optionalElement` or `nil` if `optionalElement` is not found.
    @warn_unused_result
    public func find(optionalElement: Generator.Element?) -> Generator.Element?
    {
        if let element = optionalElement
        {
            return find { $0 == element }
        }
        
        return nil
    }
}


// MARK: - at

public extension CollectionType
{
    /**
     Creates an array with the elements at the specified indexes.
     
     - parameter indexes: Indexes of the elements to get
     - returns: Array with the elements at indexes
     */
    @warn_unused_result
    func at(indexes: Index...) -> Array<Generator.Element>
    {
        return indexes.flatMap { get($0) }
    }
}

// MARK: - Last Index

public extension CollectionType
{
    /**
     The collection's last valid read index, or `nil` if the collection is empty.
     a non-nil lastIndex is a valid argument to subscript, and is always reachable from startIndex by zero or more applications of successor()
     
     - Complexity: O(1)
     */
    public var lastIndex : Index? { return isEmpty ?  nil : endIndex.advancedBy(-1) }
}

// MARK: - Uniques

public extension CollectionType where Generator.Element : Equatable
{
    /**
     Constructs an array removing the duplicate values in `self`
     
     - returns: An Array of the unique values in `self`
     */
    @warn_unused_result
    func uniques() -> Array<Generator.Element>
    {
        var result = Array<Generator.Element>()
        
        for item in self
        {
            if !result.contains(item)
            {
                result.append(item)
            }
        }
        
        return result
    }
}

extension CollectionType
{
    /**
     Returns an Array of elements for which call(element) is unique
     
     - parameter call: The closure to use to determine uniqueness
     - returns: The set of elements for which call(element) is unique
     */
    @warn_unused_result
    func uniquesBy<T: Equatable>(call: Generator.Element -> T) -> Array<Generator.Element>
    {
        var result = Array<Generator.Element>()
        var uniqueItems = Array<T>()
        
        for item in self
        {
            let callResult = call(item)
            
            if !uniqueItems.contains(callResult)
            {
                uniqueItems.append(callResult)
                result.append(item)
            }
        }
        
        return result
    }
}
