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
    /// - parameter closure : The factory code, gets invoked with integers from `0..<count`
    /// - parameter count : number of times to invoke `closure`
    public init(repeating closure: (Int) -> Element, count: Int)
    {
        self.init()
        
        (0..<count).forEach{ self.insert(closure($0)) }
    }
    
    /// Init with elements produced by calling `closure` `count` times.
    /// - parameter closure : The factory code
    /// - parameter count : number of times to invoke the `closure`
    public init(repeating closure: () -> Element, count: Int)
    {
        self.init()
        
        (0..<count).forEach{ _ in self.insert(closure()) }
    }
    
    /// Init with members produced by calling `closure` repeatedly, until it returns `nil`.
    /// - parameter closure : the closure producing members
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

// MARK: - Optionals

public extension Set
{
    /// Return a `Set` contisting of the non-nil results of applying `transform` to each member of `self`
    func map<U:Hashable>(transform: (Element) -> U?) -> Set<U>
    {
        return Set<U>(flatMap(transform))
    }
    
    /// Remove all members in `self` that are satisfy the predicate
    /// - parameter predicate : predicate to determine if the element should be removed
    mutating func remove(predicate: (Element) -> Bool)
    {
        subtract(filter(predicate))
    }

    /// Construct a new set containing only the members that satisfy the predicate; filter for sets
    /// - parameter predicate : the predicate
    /// - Returns: A `Set` consisting of the members of `self`, that satisfy `predicate`
    func sift(predicate: (Element) throws -> Bool) rethrows -> Set<Element>
    {
        return try Set(filter(predicate))
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
