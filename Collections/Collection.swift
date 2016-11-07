//
//  CollectionType.swift
//  Collections
//
//  Created by Christian Otkjær on 14/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

// MARK: - Find

public extension Collection
{
    /**
     Finds the first element which meets the condition.
     
     - parameter condition: A closure which takes an Element and returns a Bool
     - returns: First element to match contidion or nil, if none matched
     */
    func find(condition: (Generator.Element) throws -> Bool) rethrows -> Generator.Element?
    {
        if let index = try index(where: condition)
        {
            return self[index]
        }
        
        return nil
    }
}

// MARK: - Optional versions

extension Collection where Self.Iterator.Element : Equatable
{
    ///Returns the first index where `optionalElement` appears in `self` or `nil` if `optionalElement` is not found.
    public func index(of optionalElement: Iterator.Element?) -> Index?
    {
        guard let element = optionalElement else { return nil }
        
        return index { $0 == element }
    }
    
    ///Returns the first element that is equal to `optionalElement` or `nil` if `optionalElement` is not found.
    public func find(_ optionalElement: Generator.Element?) -> Generator.Element?
    {
        guard let element = optionalElement else { return nil }

        return find { $0 == element }
    }

    // MARK: - Contains

    /// Returns `true` if all elements in `collection` are also in `self`, `false` otherwise
    public func contains<C : Collection>(_ optionalCollection: C?) -> Bool where Iterator.Element == C.Iterator.Element
    {
        guard let collection = optionalCollection else { return false }
        
        return collection.all { contains($0) }
    }
}

// MARK: - at

extension Collection where Index : Strideable
{
    /**
     Creates an array with the elements at the specified indexes.
     
     - parameter indexes: Indexes of the elements to get
     - returns: Array with the elements at indexes
     */
    func at(indexes: Index...) -> Array<Generator.Element>
    {
        return indexes.flatMap { get($0) }
    }
}

// MARK: - Last Index

public extension Collection where Index : Strideable
{
    /**
     The collection's last valid read index, or `nil` if the collection is empty.
     a non-nil lastIndex is a valid argument to subscript, and is always reachable from startIndex by zero or more applications of successor()
     
     - Complexity: O(1)
     */
    public var lastIndex : Index? { return isEmpty ?  nil : endIndex.advanced(by:-1) }
}
