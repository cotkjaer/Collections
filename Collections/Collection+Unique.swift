//
//  Collection+Unique.swift
//  Collections
//
//  Created by Christian Otkjær on 06/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - Uniques

public extension Collection where Iterator.Element : Equatable
{
    /**
     Constructs an array removing the duplicate values in `self`
     
     - returns: An Array of the unique values in `self`
     */
    func uniques() -> Array<Generator.Element>
    {
        var result = Array<Generator.Element>()
        
        for item in self
        {
            if !result.contains(item)
            {
                result.append(item)
            }
        }
        
        return result
    }
}

extension Collection
{
    /**
     Returns an Array of elements for which `transform(element)` is unique
     
     - parameter call: The closure to use to determine uniqueness
     - returns: The set of elements for which call(element) is unique
     */
    func uniques<T: Equatable>(by transform: (Iterator.Element) -> T) -> Array<Iterator.Element>
    {
        var result = Array<Iterator.Element>()
        
        var uniqueItems = Array<T>()
        
        for item in self
        {
            let callResult = transform(item)
            
            if !uniqueItems.contains(callResult)
            {
                uniqueItems.append(callResult)
                result.append(item)
            }
        }
        
        return result
    }
}
