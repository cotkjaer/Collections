//
//  Queue.swift
//  Collections
//
//  Created by Christian Otkjær on 08/10/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

public class Queue<Element>
{
    private var linkedList = LinkedList<Element>()
    
    public func enqueue(element: Element)
    {
        linkedList.append(element)
    }
    
    public func dequeue() -> Element?
    {
        return linkedList.popFirst()
    }

    public var isEmpty : Bool { return linkedList.isEmpty }
    
    public var count: Int { return linkedList.count }
}

// MARK: - Contains

extension Queue where Element : Equatable
{
    public func contains(element: Element) -> Bool
    {
        return linkedList.contains(element)
    }
}
