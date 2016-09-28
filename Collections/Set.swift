//
//  Set.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

//MARK: - Functional Inits

public extension Set
{
    /// Init with elements produced by calling `block`, `count`times.
    init(count: Int, block: (Int) -> Element)
    {
        self.init()
        
        for i in 0..<count
        {
            insert(block(i))
        }
    }
    
    /// Init with elements produced by calling `block` until it returns `nil`.
    /// -warning: Calls `block` until it returns nil
    init(block: () -> Element?)
    {
        self.init()
        
        while let e = block()
        {
            insert(e)
        }
    }
}

// MARK: - Operators

public func - <T, S : Sequence>(lhs: Set<T>, rhs: S) -> Set<T> where S.Iterator.Element == T
{
    return lhs.subtracting(rhs)
}

public func + <T, S : Sequence>(lhs: Set<T>, rhs: S) -> Set<T> where S.Iterator.Element == T
{
    return lhs.union(rhs)
}

// MARK: - Operators with optional arguments

public func + <T>(lhs: Set<T>?, rhs: T) -> Set<T>
{
    return Set(rhs).union(lhs)
}

public func + <T>(lhs: T, rhs: Set<T>?) -> Set<T>
{
    return rhs + lhs
}

public func += <T, S : Sequence>(lhs: inout Set<T>, rhs: S?) where S.Iterator.Element == T
{
    guard let rhs = rhs else { return }

    lhs = lhs + rhs
}

public func += <T>(lhs: inout Set<T>, rhs: T?)
{
    let _ = lhs.insert(rhs)
}

public func - <T, S : Sequence>(lhs: Set<T>, rhs: S?) -> Set<T> where S.Iterator.Element == T
{
    if let r = rhs
    {
        return lhs - r
    }
    
    return lhs
}


public func - <T>(lhs: Set<T>, rhs: T?) -> Set<T>
{
    return lhs - Set(rhs)
}

public func -= <T, S : Sequence>(lhs: inout Set<T>, rhs: S?) where S.Iterator.Element == T
{
    lhs.subtractInPlace(rhs)
}

public func -= <T>(lhs: inout Set<T>, rhs: T?)
{
    let _ = lhs.remove(rhs)
}



// MARK: - Optionals

public extension Set
{
    /**
     Initializes a set from the non-nil elements in `elements`
     
     - parameter elements: list of optional members for the set
     */
    init(_ elements: Element?...)
    {
        self.init(elements)
    }
    
    init(_ optionalMembers: [Element?])
    {
        self.init(optionalMembers.flatMap{ $0 })
    }
    
    init(_ optionalArray: [Element]?)
    {
        self.init(optionalArray ?? [])
    }
    
    init(_ optionalArrayOfOptionalMembers: [Element?]?)
    {
        self.init(optionalArrayOfOptionalMembers ?? [])
    }

    func union<S : Sequence>(_ sequence: S?) -> Set<Element> where S.Iterator.Element == Element
    {
        if let s = sequence
        {
            return union(s)
        }
        
        return self
    }
    
    mutating func formUnion<S : Sequence>(_ sequence: S?) where S.Iterator.Element == Element
    {
        if let s = sequence
        {
            formUnion(s)
        }
    }

    mutating func subtractInPlace<S : Sequence>(_ sequence: S?) where S.Iterator.Element == Element
    {
        if let s = sequence
        {
            subtract(s)
        }
    }

    
    /// Insert an optional element into the set
    /// - returns: **true** if the element was inserted, **false** otherwise
    mutating func insert(_ optionalElement: Element?) -> Bool
    {
        if let element = optionalElement
        {
            if !contains(element)
            {
                insert(element)
                return true
            }
        }
        
        return false
    }

    /// Insert an optional element into the set
    /// - returns: **true** if the element was inserted, **false** otherwise
    mutating func remove(_ optionalElement: Element?) -> Element?
    {
        if let element = optionalElement
        {
            return remove(element)
        }
        
        return nil
    }

    
    /// Return a `Set` contisting of the non-nil results of applying `transform` to each member of `self`
    
    func map<U:Hashable>(_ transform: (Element) -> U?) -> Set<U>
    {
        return Set<U>(flatMap(transform))
    }
    
    ///Remove all members in `self` that are accepted by the predicate
    mutating func remove(_ predicate: (Element) -> Bool)
    {
        subtract(filter(predicate))
    }
    
    /// Return a `Set` contisting of the members of `self`, that satisfy the predicate `includeMember`.
    
    func sift(_ includeMember: (Element) throws -> Bool) rethrows -> Set<Element>
    {
        return try Set(filter(includeMember))
    }
    
    /// Return a `Set` contisting of the members of `self`, that are `T`s
    
    func cast<T:Hashable>(_ type: T.Type) -> Set<T>
    {
        return map{ $0 as? T }
    }
    
    /// Returns **true** `optionalMember` is non-nil and contained in `self`, **false** otherwise.
    
    func contains(_ optionalMember: Element?) -> Bool
    {
        if let m = optionalMember
        {
            return contains(m)
        }
        return false
        //optionalMember?.isIn(self) == true
    }
}

// MARK: - Subsets

public extension Set
{
    /// Returns **all** the subsets of this set. That might be quite a lot!
    
    func subsets() -> Set<Set<Element>>
    {
        var subsets = Set<Set<Element>>()
        
        if count > 1
        {
            if let element = first
            {
                subsets.insert(Set<Element>(element))
                
                let rest = self - element
                
                subsets.insert(rest)
                
                for set in rest.subsets()
                {
                    subsets.insert(set)
                    subsets.insert(set + element)
                }
            }
        }
        
        return subsets
    }
}
