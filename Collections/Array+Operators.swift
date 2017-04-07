//
//  Array+Operators.swift
//  Collections
//
//  Created by Christian Otkjær on 06/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation
/**
 Add a optional array
 */
infix operator ?+: AdditionPrecedence //{ associativity left precedence 130 }

public func ?+ <T> (first: [T], optionalSecond: [T]?) -> [T]
{
    if let second = optionalSecond
    {
        return first + second
    }
    else
    {
        return first
    }
}

infix operator ?+=: AdditionPrecedence // { associativity right precedence 90 }

public func ?+= <T> (left: inout [T], optionalRight: [T]?)
{
    if let right = optionalRight
    {
        left += right
    }
}

/**
 Remove an element from the array
 */
public func - <T: Equatable> (first: [T], second: T) -> [T]
{
    return first - [second]
}

/**
 Difference operator
 */
public func - <T: Equatable> (first: [T], second: [T]) -> [T]
{
    return first.filter { !second.contains($0) }
}

/**
 Intersection operator
 */
public func & <T: Equatable> (first: [T], second: [T]) -> [T]
{
    return first.filter { second.contains($0) }
}

/**
 Union operator
 */
public func | <T: Equatable> (first: [T], second: [T]) -> [T]
{
    return first + (second - first)
}
