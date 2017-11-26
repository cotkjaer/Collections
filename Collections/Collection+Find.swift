//
//  Collection+Find.swift
//  Collections
//
//  Created by Christian Otkjær on 26/11/2017.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import Foundation

extension Collection
{
    public func find(where predicate: (Element) -> Bool) -> Element?
    {
        guard let index = self.index(where: predicate) else { return nil }
        
        return self[index]
    }
}

extension Collection where Element: Equatable
{
    public func find(_ element: Element?) -> Element?
    {
        guard let element = element else { return nil }
        
        guard let index = self.index(of: element) else { return nil }
        
        return self[index]
    }
}
