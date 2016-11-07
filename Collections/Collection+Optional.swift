//
//  Collection+Optional.swift
//  Collections
//
//  Created by Christian Otkjær on 06/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

// MARK: - Get

public extension Collection where Index : Strideable
{
    /**
     Gets the element at the specified (optional) index, if it exists and is within the collections bounds.
     
     - parameter optionaleIndex: the optional index to look up
     - returns: the element at the index in `self`
     */
    func get(_ index: Index?) -> Generator.Element?
    {
        guard let index = index else { return nil }
        
        guard startIndex.distance(to:index) >= 0 else { return nil }
        
        guard index.distance(to:endIndex) > 0 else { return nil }
        
        return self[index]
    }

}
