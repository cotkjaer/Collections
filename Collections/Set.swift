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
    /// Init with elements produced by calling `closure` `count` times.
    /// - parameter closure: The factory code, gets invoked with integers from `0..<count`
    /// - parameter count: number of times to invoke `closure`
    public init(repeating closure: (Int) -> Element, count: Int)
    {
        self.init()
        
        (0..<count).forEach{ self.insert(closure($0)) }
    }
    
    /// Init with elements produced by calling `closure` `count` times.
    /// - parameter closure: The factory code
    /// - parameter count: number of times to invoke the `closure`
    public init(repeating closure: () -> Element, count: Int)
    {
        self.init()
        
        (0..<count).forEach{ _ in self.insert(closure()) }
    }
    
    /// Init with members produced by calling `closure` repeatedly, until it returns `nil`.
    /// - parameter closure: the closure producing members
    /// - warning: Calls `closure` until it returns nil
    init(repeating closure: () -> Element?)
    {
        self.init()
        
        while let e = closure()
        {
            insert(e)
        }
    }
}

// MARK: - map and filter

extension Set
{
    /// Return a `Set` contisting of the non-nil results of applying `transform` to each member of `self`
    public func map<E:Hashable>(_ transform: (Element) -> E?) -> Set<E>
    {
        return Set<E>(compactMap(transform))
    }
    
    /// Remove all members in `self` that satisfy the predicate; the reverse of `filter`
    /// - parameter predicate: predicate to determine if the element should be removed
    public mutating func reject(_ predicate: (Element) -> Bool)
    {
        subtract(filter(predicate))
    }
    
    /// Construct a new set containing only the members that satisfy the predicate; filter for sets
    /// - parameter predicate: the predicate
    /// - Returns: A `Set` consisting of the members of `self`, that satisfy `predicate`
    public func sift(_ predicate: (Element) throws -> Bool) rethrows -> Set<Element>
    {
        return try Set(filter(predicate))
    }
}

// MARK: - Subsets

public extension Set
{
    /** Creates a set of the strict subsets of this set (save the empty set)
    - note: That might be quite a lot!
    */
    func subsets() -> Set<Set<Element>>
    {
        guard count > 1 else { return Set<Set<Element>>() }
        
        var rest = self
        let element = rest.removeFirst()

        var subsets = Set<Set<Element>>()

        subsets.insert(Set(element))
        subsets.insert(rest)
        
        for set in rest.subsets()
        {
            subsets.insert(set)
            subsets.insert(set + element)
        }
        
        return subsets
    }
}
