//
//  Stack.swift
//  Collections
//
//  Created by Christian Otkjær on 26/05/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

/// Classic Stack
public class Stack<Element>
{
    private var elements: [Element] = Array<Element>()
    
    public var isEmpty: Bool { return elements.isEmpty }
    
    public func push(element: Element) { elements.append(element) }
    
    public func pop() -> Element { return elements.removeLast() }
    
    public func pop() -> Element? { return isEmpty ? nil : elements.removeLast() }
}