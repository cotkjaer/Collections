//
//  List.swift
//  Collections
//
//  Created by Christian Otkjær on 08/10/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

struct List<Element>
{
    fileprivate var array: Array<Element>
    
    var count : Int { return array.count }
    
    var tail : List<Element>?
        {
            switch count
            {
            case 0, 1: return nil
                
            case 2: return List(array: [array[1]])
                
            default: return List(array: Array(array[1..<count]))
            }
    }
    
    var head : Element? { return array.first }
}


private class Link<E>
{
    var element: E

    var next: Link<E>?
    var previous: Link<E>?

    init(element: E)
    {
        self.element = element
    }
    
    func append(_ element: E) -> Link<E>
    {
        let link = Link(element: element)
        
        self.next = link
        link.previous = self
        
        return link
    }
    
    func prepend(_ element: E) -> Link<E>
    {
        let link = Link(element: element)
        
        self.previous = link
        link.next = self
        
        return link
    }
}

public struct LinkedList<Element>
{
    fileprivate var array = Array<Element>()
    
    fileprivate var head: Link<Element>?
    fileprivate var tail: Link<Element>?
    
    var isEmpty : Bool { return head == nil && tail == nil }
    
    var count : Int { var c = 0; var link = head; while link != nil { c += 1; link = link?.next }; return c }
    
    mutating func popFirst() -> Element?
    {
        if let element = head?.element
        {
            head = head?.next
            
            if head == nil
            {
                tail = nil
            }
            
            return element
        }
        
        return nil
    }
    
    mutating func popLast() -> Element?
    {
        if let element = tail?.element
        {
            tail = tail?.previous
            
            if tail == nil
            {
                head = nil
            }
            
            return element
        }
        
        return nil
    }
    
    mutating func append(_ element: Element)
    {
        if isEmpty
        {
            let link = Link(element: element)
            
            head = link
            tail = link
        }
        else
        {
            tail = tail?.append(element)
        }
    }
    
    mutating func prepend(_ element: Element)
    {
        if isEmpty
        {
            let link = Link(element: element)
            
            head = link
            tail = link
        }
        else
        {
            head = head?.prepend(element)
        }
    }
    
    public func contains(_ check: (Element) -> Bool) -> Bool
    {
        var link = head
        
        var found = false
        
        while link != nil && !found
        {
            if check(link!.element)
            {
                found = true
            }
            else
            {
                link = link?.next
            }
        }
        
        return found
    }
}

// MARK: - Contains

extension LinkedList where Element : Equatable
{
    public func contains(_ element: Element) -> Bool
    {
        return contains({ $0 == element })
    }
}


