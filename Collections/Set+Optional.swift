//
//  Set+Optional.swift
//  Collections
//
//  Created by Christian Otkjær on 06/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation
// MARK: - Optionals

// MARK: - <#comment#>

extension Set: NilTollerableCollection { }


public extension Set
{
    /**
     Initializes a set from the non-nil members in `members`
     
     - parameter members: list of optional members for the set
     */
    public init(_ members: Element?...)
    {
        self = Set(members.compactMap{$0})
    }
        
    func union<S: Sequence>(_ optionalSequence: S?) -> Set<Element> where S.Iterator.Element == Element
    {
        guard let sequence = optionalSequence else { return self }

        return union(sequence)
    }
    
    mutating func formUnion<S: Sequence>(_ optionalSequence: S?) where S.Iterator.Element == Element
    {
        guard let sequence = optionalSequence else { return }
 
        formUnion(sequence)
    }
    
    mutating func subtract<S: Sequence>(_ optionalSequence: S?) where S.Iterator.Element == Element
    {
        guard let sequence = optionalSequence else { return }

        subtract(sequence)
    }
    
    /// Insert an optional member into the set
    /// - returns: **true** if the member was inserted, **false** otherwise
    mutating func insert(_ optionalMember: Element?) -> Bool
    {
        guard let member = optionalMember, !contains(member) else { return false }

        insert(member)
        return true
    }
    
    /// Remove an optional member from the set
    /// - returns: the removed if a member was removed, nil otherwise
    mutating func remove(_ member: Element?) -> Element?
    {
        guard let member = member else { return nil }
        
        return remove(member)
    }
    
    /** Removes all members passing the test
    - parameter test: The predicate used to sort out the members to remove
    - returns: A set of the **removed** members
     */
    @discardableResult
    mutating func remove(where test: (Element) -> Bool) -> Set<Element>
    {
        let removed = sift(test)
        subtract(removed)
        return removed
    }
    
    /** Removes all elements passing the test
     - parameter test: The predicate used to sort out the elements to remove
     - returns: The remaining members
     */
    func removing(where test: (Element) -> Bool) -> Set<Element>
    {
        return sift({ !test($0) })
    }
    
    
    /// - parameter optionalMember: the member to look for
    /// - Returns: `self.contains(optionalMember!)` if `optionalMember` is non-nil, **false** otherwise.
    func contains(_ optionalMember: Element?) -> Bool
    {
        guard let member = optionalMember else { return false }
        
        return contains(member)
    }
}
