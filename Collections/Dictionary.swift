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

// MARK: - Get

extension Dictionary
{
    /**
     Gets the value at the specified optional key, if it exists
     
     - parameter key: the optional key to look up
     - returns: the value at the key in `self`
     */
    public func get(_ key: Key?) -> Value?
    {
        guard let key = key else { return nil }
        
        return self[key]
    }
}


extension Dictionary
{
    public func mapPairs<OutKey: Hashable, OutValue>(transform: (Element) throws -> (OutKey, OutValue)) rethrows -> Dictionary<OutKey, OutValue>
    {
        return Dictionary<OutKey, OutValue>(try map(transform))
    }
    
    public func filterPairs(includeElement: (_ key: Key, _ value: Value) throws -> Bool) rethrows -> Dictionary<Key, Value>
    {
        return Dictionary(try filter(includeElement))
    }
    
    public func filterPairs(includeElement: (Element) throws -> Bool) rethrows -> Dictionary<Key, Value>
    {
        return Dictionary(try filter(includeElement))
    }
}

extension Dictionary
{
    public func map<OutValue>(transform: (Value) throws -> OutValue) rethrows -> Dictionary<Key, OutValue>
    {
        return Dictionary<Key, OutValue>(try map { (k, v) in (k, try transform(v)) })
    }

    public func compactMap<OutValue>(transform: (Value) throws -> OutValue?) rethrows -> Dictionary<Key, OutValue>
    {
        return Dictionary<Key, OutValue>(try compactMap { (k, v) in if let vv = try transform(v) { return (k, vv) } else { return nil } })
    }
}
