//
//  Queue.swift
//  Collections
//
//  Created by Christian Otkjær on 08/10/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

open class Queue<Element>
{
    fileprivate var linkedList = LinkedList<Element>()
    
    open func enqueue(_ element: Element)
    {
        linkedList.append(element)
    }
    
    open func dequeue() -> Element?
    {
        return linkedList.popFirst()
    }

    open var isEmpty : Bool { return linkedList.isEmpty }
    
    open var count: Int { return linkedList.count }
}

// MARK: - Contains

extension Queue where Element : Equatable
{
    public func contains(_ element: Element) -> Bool
    {
        return linkedList.contains(element)
    }
}
