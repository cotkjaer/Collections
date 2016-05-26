//
//  File.swift
//  Collections
//
//  Created by Christian Otkjær on 25/05/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

extension Dictionary
{
    public init(_ pairs: [Element])
    {
        self.init()
    
        for (k, v) in pairs
        {
            self[k] = v
        }
    }
}

extension Dictionary
{
    @warn_unused_result
    public func mapPairs<OutKey: Hashable, OutValue>(@noescape transform: Element throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue]
    {
        return Dictionary<OutKey, OutValue>(try map(transform))
    }
    
    @warn_unused_result
    public func filterPairs(@noescape includeElement: Element throws -> Bool) rethrows -> [Key: Value]
    {
        return Dictionary(try filter(includeElement))
    }
}

extension Dictionary
{
    @warn_unused_result
    public func map<OutValue>(@noescape transform: Value throws -> OutValue) rethrows -> [Key: OutValue]
    {
        return Dictionary<Key, OutValue>(try map { (k, v) in (k, try transform(v)) })
    }
}