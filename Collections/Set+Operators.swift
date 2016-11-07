//
//  Set+Operators.swift
//  Collections
//
//  Created by Christian Otkjær on 06/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

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
    lhs.subtract(rhs)
}

public func -= <T>(lhs: inout Set<T>, rhs: T?)
{
    let _ = lhs.remove(rhs)
}
