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
    public func append(element : Element?)
    {
        guard let element = element else { return }
        
        append(element: element)
    }
}
