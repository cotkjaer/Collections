//
//  Array+Search.swift
//  Collections
//
//  Created by Christian Otkjær on 06/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

extension Array
{
    
    /**
     Does a binary search to find the **last** element for which the predicate evaluates to `true`.
     
     The predicate should return `true` for all elements in the array below a certain index and `false` for all elements above that index
     
     - parameter predicate: the predicate to test elements
     - returns: The found index and element, or `nil` if there are no elements in the array for which the predicate returns `true`
     */
    
    public func last(where predicate: (Element) -> Bool) -> (Int, Element)?
    {
        guard count > 0 else { return nil }
        
        var low = 0
        var high = count - 1
        
        while low <= high
        {
            let mid = (high + low) / 2
            
            if predicate(self[mid])
            {
                if mid == high || !predicate(self[mid + 1])
                {
                    return (mid, self[mid])
                }
                else
                {
                    low = mid + 1
                }
            }
            else
            {
                high = mid - 1
            }
        }
        
        return nil
    }

    

    /**
     Does a binary search to find the smallest/first element for which the predicate evaluates to true.
     - Note: The predicate should return true for all elements in the array above a certain index and false for all elements below that index
     
     - parameter predicate: the predicate to test each element
     - returns: The smallest index and element at that index for which the predicates is true. `nil` if there are no elements for which the predicate is true
     */
    public func search(_ predicate: (Element) -> Bool) -> (Int, Element)?
    {
        if count == 0
        {
            return nil
        }
        
        var low = 0
        var high = count - 1
        while low <= high
        {
            let mid = low + (high - low) / 2
            
            if predicate(self[mid])
            {
                if mid == 0 || !predicate(self[mid - 1])
                {
                    return (mid, self[mid])
                }
                else
                {
                    high = mid
                }
            }
            else
            {
                low = mid + 1
            }
        }
        
        return nil
    }
    
    /**
     Does a binary search to find some element for which the closure returns 0.
     The closure should return a negative number if the current value is before the target in the array, 0 if it's the target, and a positive number if it's after the target
     The Spaceship operator is a perfect fit for this operation, e.g. if you want to find the object with a specific date and name property, you could keep the array sorted by date first, then name, and use this call:
     `let match = search { [targetDate, targetName] <=> [$0.date, $0.name] }`
     
     See http://ruby-doc.org/core-2.2.0/Array.html#method-i-bsearch regarding find-any mode for more
     
     - parameter closure: the closure to run each time
     - returns: an item (there could be multiple matches) for which the closure returns 0
     */
    func search (_ closure: (Element) -> Int) -> Element?
    {
        let match = search { closure($0) >= 0 }
        
        if let (_, element) = match
        {
            return closure(element) == 0 ? element : nil
        }
        else
        {
            return nil
        }
    }
}
