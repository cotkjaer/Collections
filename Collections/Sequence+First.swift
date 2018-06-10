//
//  Sequence+First.swift
//  Collections
//
//  Created by Christian Otkjær on 26/11/2017.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import Foundation

extension Sequence
{
    /** find the first element in `self` that is of the infered type `T`
    - returns: The first element in `self` that `is T` (cast as a T), or nil if none are
     */
    public func first<T>() -> T?
    {
        return first(where: {$0 is T}) as? T
    }
}

extension Sequence where Element: Equatable
{
    /** find the first element in `self` that is equal to the (optional) element
     
    - parameter element: The element to look for
     
    - returns: The first element in `self` that is equal to argument, or nil if none are
     */
    public func first(_ element: Element?) -> Element?
    {
        guard let element = element else { return nil }
        
        return first(where: { $0 == element })
    }
}
