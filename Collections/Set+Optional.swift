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
        self = Set(members.flatMap{$0})
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
    /// - returns: **true** if the member was removed, **false** otherwise
    mutating func remove(_ optionalMember: Element?) -> Element?
    {
        guard let member = optionalMember else { return nil }
        
        return remove(member)
    }
    
    /// - parameter optionalMember: the member to look for
    /// - Returns: `self.contains(optionalMember!)` if `optionalMember` is non-nil, **false** otherwise.
    func contains(_ optionalMember: Element?) -> Bool
    {
        guard let member = optionalMember else { return false }
        
        return contains(member)
    }
}
