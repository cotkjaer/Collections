//
//  Set+Cast.swift
//  Collections
//
//  Created by Christian Otkjær on 06/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

extension Set
{
    /// Return a `Set` contisting of the members of `self`, that are `T`s
    public func cast<T:Hashable>(_ type: T.Type) -> Set<T>
    {
        return map { $0 as? T }
    }
    
    /// Return a `Set` contisting of the members of `self`, that are `T`s
    public func cast<T:Hashable>() -> Set<T>
    {
        return map { $0 as? T }
    }
}
