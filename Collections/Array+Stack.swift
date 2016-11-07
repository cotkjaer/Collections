//
//  Array+Stack.swift
//  Collections
//
//  Created by Christian Otkjær on 07/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - Stack operations
extension Array
{
    /**
     Treats the array as a Stack; removing the last element of the array and returning it.
     
     - returns: The removed element, or nil if the array is empty
     */
    mutating func pop() -> Element?
    {
        return isEmpty ? nil : removeLast()
    }
    
    /**
     Treats the array as a Stack; appending the list of elements to the end of the array.
     
     - parameter elements: The elements to append
     */
    mutating func push(_ elements: Element...)
    {
        switch elements.count
        {
        case 0: return
            
        case 1: append(elements[0])
            
        default: self += elements
        }
    }

    /**
     Treats the array as a Stack; appending the optional element to the end of the array.
     
     - parameter optionalElement: The optional element to append
     */
    mutating func push(_ optionalElement: Element?)
    {
        append(optionalElement)
    }
}
