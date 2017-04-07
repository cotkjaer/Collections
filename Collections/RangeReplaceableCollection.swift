//
//  RangeReplaceableCollectionType.swift
//  Collections
//
//  Created by Christian Otkjær on 15/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

public extension RangeReplaceableCollection where Index: Strideable
{
    /**
     Sets the element at the specified optional index, if it exists and is within the collections bounds.
     
     - parameter index: the optional index to look up
     - returns: the element at the index in `self`
     */
    
    public mutating func set(element: Generator.Element?, at index: Index?) -> Generator.Element?
    {
        guard let index = index else { return nil }
        
        guard let element = element else { return nil }
        
        guard startIndex.distance(to:index) >= 0 else { return nil }

        let distanceToEnd = index.distance(to:endIndex)
        
        guard distanceToEnd >= 0 else { return nil }
        
        if distanceToEnd > 0
        {
            replaceSubrange(index..<index.advanced(by:1), with: [element])
        }
        else
        {
            append(element)
        }

        return element
    }
}

public extension RangeReplaceableCollection
{
    /**
     Insert an optional element at `index`
     - Note: Invalidates all indices with respect to self.
     - parameter element: Element to insert
     - parameter index: index at which to insert element, must be <= `self.count`
     - Complexity: O(`self.count`)
     - Returns: the inserted element iff it was inserted
     */
    @discardableResult
    mutating func insert(_ optionalElement: Generator.Element?, at index: Self.Index) -> Generator.Element?
    {
        if let element = optionalElement
        {
            insert(element, at: index)
        }
        
        return optionalElement
    }
    
    /**
     Prepends an element to the front of `self` i.e. inserts it at `startIndex`.
     
     - parameter element: Element to prepend
     
     - returns: element iff it was prepended, nil otherwise
     */
    @discardableResult
    mutating func prepend(_ optionalElement: Generator.Element?) -> Generator.Element?
    {
        return insert(optionalElement, at: startIndex)
    }

    /**
     Appends a new element to the end of `self` i.e. inserts it at `endIndex`.
     
     - parameter element: Element to append
     
     - returns: element iff it was appended, nil otherwise
     */
    @discardableResult
    mutating func append(_ optionalElement: Generator.Element?) -> Generator.Element?
    {
        return insert(optionalElement, at: endIndex)
    }
}
