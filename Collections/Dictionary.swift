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
    public func mapPairs<OutKey: Hashable, OutValue>(@noescape transform: Element throws -> (OutKey, OutValue)) rethrows -> Dictionary<OutKey, OutValue>
    {
        return Dictionary<OutKey, OutValue>(try map(transform))
    }
    
    @warn_unused_result
    public func filterPairs(@noescape includeElement: (key: Key, value: Value) throws -> Bool) rethrows -> Dictionary<Key, Value>
    {
        return Dictionary(try filter(includeElement))
    }
    
    @warn_unused_result
    public func filterPairs(@noescape includeElement: Element throws -> Bool) rethrows -> Dictionary<Key, Value>
    {
        return Dictionary(try filter(includeElement))
    }
}

extension Dictionary
{
    @warn_unused_result
    public func map<OutValue>(@noescape transform: Value throws -> OutValue) rethrows -> Dictionary<Key, OutValue>
    {
        return Dictionary<Key, OutValue>(try map { (k, v) in (k, try transform(v)) })
    }

    @warn_unused_result
    public func flatMap<OutValue>(@noescape transform: Value throws -> OutValue?) rethrows -> Dictionary<Key, OutValue>
    {
        return Dictionary<Key, OutValue>(try flatMap { (k, v) in if let vv = try transform(v) { return (k, vv) } else { return nil } })
    }

}