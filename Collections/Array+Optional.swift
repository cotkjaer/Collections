//
//  Array+Optional.swift
//  Collections
//
//  Created by Christian Otkjær on 07/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - Optional

extension Array
{
    public init?<C: Collection>(optionalCollection: C?) where C.Iterator.Element == Element
    {
        guard let collection = optionalCollection else { return nil }
        
        self.init(collection)
    }
}
