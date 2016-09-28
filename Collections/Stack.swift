//
//  Stack.swift
//  Collections
//
//  Created by Christian Otkjær on 26/05/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

/// Classic Stack
open class Stack<Element>
{
    fileprivate var elements: [Element] = Array<Element>()
    
    open var isEmpty: Bool { return elements.isEmpty }
    
    open func push(_ element: Element) { elements.append(element) }
    
    open func pop() -> Element { return elements.removeLast() }
    
    open func pop() -> Element? { return isEmpty ? nil : elements.removeLast() }
}
