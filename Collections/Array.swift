//
//  Array.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 05/05/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

//MARK: - Functional Inits

public extension Array
{
    /// Init with elements produced by calling `closure` `count` times.
    /// - parameter closure : The factory code, gets invoked with integers from `0..<count`
    /// - parameter count : number of times to invoke the factory code
    public init(repeating closure: (Int) -> Element, count: Int)
    {
        self = (0..<count).map(closure)
    }
    
    /// Init with elements produced by calling `closure` `count` times.
    /// - parameter closure : The factory code
    /// - parameter count : number of times to invoke the factory code
    public init(repeating closure: () -> Element, count: Int)
    {
        self = (0..<count).map { _ in closure() }
    }
    
    /// Init with elements produced by calling `closure` `count` times.
    @available(*, deprecated) init(count: Int, closure: (Int) -> Element)
    {
        self.init()
        
        for i in 0..<count
        {
            append(closure(i))
        }
    }
    
    /// Init with elements produced by calling `closure` until it returns `nil`.
    /// - warning: Calls `closure` until it returns nil, if closure never does, the code hangs
    init(closure: () -> Element?)
    {
        self.init()
        
        while let e = closure()
        {
            append(e)
        }
    }
}

public extension Array
{
    /**
     Creates a dictionary with an optional entry for every element in the array.
     
     - Note: Different calls to *transform* may yield the same *result-key*, the later call overwrites the value in the dictionary with its own *result-value*
     
     - Parameter transform: closure to apply to the elements in the array
     - Returns: the dictionary compiled from the results of calling *transform* on each element in array
     */
    func mapToDictionary<K:Hashable, V>(_ transform: (Element) -> (K, V)?) -> Dictionary<K, V>
    {
        var d = Dictionary<K, V>()
        
        forEach { (e) in
            if let (k, v) = transform(e) { d[k] = v }
        }
        
        return d
    }
}


// MARK: - Changes

public extension Array where Element : Equatable
{
    func missingIndicies(_ otherArray: Array<Element>) -> [Index]
    {
        return enumerated().filter{!otherArray.contains($0.element)}.map{ $0.offset }
    }
}

