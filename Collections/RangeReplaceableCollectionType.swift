//
//  RangeReplaceableCollectionType.swift
//  Collections
//
//  Created by Christian Otkjær on 15/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

public extension RangeReplaceableCollectionType //where Index : Comparable
{
    /**
     Sets the element at the specified optional index, if it exists and is within the collections bounds.
     
     - parameter optionaleIndex: the optional index to look up
     - returns: the element at the index in `self`
     */
    @warn_unused_result
    public mutating func set(element: Generator.Element?, at optionaleIndex: Index?) -> Generator.Element?
    {
        guard let index = optionaleIndex else { return nil }
        
        guard let element = element else { return nil }
        
        guard startIndex.distanceTo(index) >= 0 else { return nil }

        let distanceToEnd = index.distanceTo(endIndex)
        
        guard distanceToEnd >= 0 else { return nil }
        
        if distanceToEnd > 0
        {
            replaceRange(index..<index.advancedBy(1), with: [element])
        }
        else
        {
            append(element)
        }

        return element
    }
}

public extension RangeReplaceableCollectionType
{
    /**
     Prepends an element to the front of `self` i.e. inserts it at `startIndex`.
     
     - parameter element: Element to prepend
     
     - returns: element iff it was prepended, nil otherwise
     */
    mutating func prepend(element: Generator.Element?) -> Generator.Element?
    {
        return insert(element, atIndex: startIndex)
    }

    /**
     Appends a new element to the end of `self` i.e. inserts it at `endIndex`.
     
     - parameter element: Element to append
     
     - returns: element iff it was appended, nil otherwise
     */
    mutating func append(element: Generator.Element?) -> Generator.Element?
    {
        return insert(element, atIndex: endIndex)
    }
    
    /**
     Insert an optional element at `index`
     - Note: Invalidates all indices with respect to self.
     - parameter element: Element to insert
     - parameter index: index at which to insert element, must be <= `self.count`
     - Complexity: O(`self.count`)
     - Returns: the inserted element iff it was inserted
     */
    mutating func insert(element: Generator.Element?, atIndex index: Self.Index) -> Generator.Element?
    {
        if let element = element
        {
            insert(element, atIndex: index)
        }
    
        return element
    }
    
    
//    /**
//     The collection's last valid index, or nil if the collection is empty.
//     a non-nil lastIndex is a valid argument to subscript, and is always reachable from startIndex by zero or more applications of successor()
//     
//     - Complexity: O(1)
//     */
//    public var lastIndex : Index? { return isEmpty ?  nil : endIndex.advancedBy(-1) }
}
