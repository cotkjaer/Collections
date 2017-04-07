//
//  Array+Queue.swift
//  Collections
//
//  Created by Christian Otkjær on 07/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - Queue operations
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
        return isEmpty ? nil: removeFirst()
    }
    
}
