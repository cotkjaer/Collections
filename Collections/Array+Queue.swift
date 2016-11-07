//
//  Array+Queue.swift
//  Collections
//
//  Created by Christian Otkjær on 07/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: List , Queue and Stack operations
extension Array
{
    /**
     Treats the array as a Queue; adding a new element to the end of the queue
     
     - returns: The removed element, or nil if the array is empty
     */
    public mutating func enqueue(_ element: Element?)
    {
        append(element)
    }
    
    /**
     Treats the array as a Queue; removing the first element in the array and returning it.
     
     - returns: The removed element, or nil if the array is empty
     */
    public mutating func dequeue() -> Element?
    {
        return isEmpty ? nil : removeFirst()
    }

    
    /**
     Treats the array as a Stack; removing the last element of the array and returning it.
     
     - returns: The removed element, or nil if the array is empty
     */
    mutating func pop() -> Element?
    {
        return isEmpty ? nil : removeLast()
    }
    
    /**
     Treats the array as a Stack or Queue; appending the list of elements to the end of the array.
     
     - parameter elements: The elements to append
     */
    mutating func push(_ elements: Element...)
    {
        switch elements.count
        {
        case 0: return
            
        case 1: self.append(elements[0])
            
        default: self += elements
        }
    }
    
    /**
     Treats the array as a Queue; removing the first element in the array and returning it.
     
     - returns: The removed element, or nil if the array is empty
     */
    mutating func shift() -> Element?
    {
        return isEmpty ? nil : removeFirst()
    }
    
    /**
     Prepends a list of elements to the front of the array. The elements are prepended as a list, **not** one at a time. Thus the order in the list is preserved in the array
     
     - parameter elements: The elements to prepend
     */
    mutating func unshift(_ elements: Element...)
    {
        switch elements.count
        {
        case 0: return
            
        case 1: self.insert(elements[0], at: 0)
            
        default: self = elements + self
        }
    }
}
