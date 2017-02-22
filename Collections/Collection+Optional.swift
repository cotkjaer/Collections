//
//  Collection+Optional.swift
//  Collections
//
//  Created by Christian Otkjær on 06/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

// MARK: - Get

public protocol NilTollerableCollection: Collection
{
    init<S: Sequence>(_ elements: S) where S.Iterator.Element == Iterator.Element

    /**
     Creates collection containing the non-nil elements of the given sequence.
     - parameter optionals: The sequence of optional elements for the new collection. optionals must be finite.
     - returns: **nil** if the `optionals` is **nil**
     */
    init?<S: Sequence>(optionals: S?) where S.Iterator.Element == Iterator.Element
    
    /** Creates collection from the given non-nil optional elements
     
     - parameter optionals: list of optional elements to include in the new collection
     */
    init(literalOptionals: Iterator.Element?...)

    /** Creates collection from the given non-nil optional elements
     
     - parameter optionals: sequence of optional elements to include in the new collection
     */
    init<S: Sequence>(optionals: S) where S.Iterator.Element == Iterator.Element?

    /** Creates collection from the given non-nil optional elements
     
     - parameter optionals: optional sequence of optional elements to include in the new collection
     - returns: **nil** if the `optionals` is **nil**
     */
    init?<S: Sequence>(optionals: S?) where S.Iterator.Element == Iterator.Element?
}


// MARK: - <#comment#>

extension NilTollerableCollection
{
    public init?<S: Sequence>(optionals: S?) where S.Iterator.Element == Iterator.Element
    {
        guard let elements = optionals else { return nil }
        
        self.init(elements)
    }
    
    public init(literalOptionals optionals: Iterator.Element?...)
    {
        self.init(optionals: optionals)
    }
    
    public init<S: Sequence>(optionals: S) where S.Iterator.Element == Iterator.Element?
    {
        let elements = optionals.flatMap { $0 }
        
        self.init(elements)
    }
    
    public init?<S: Sequence>(optionals: S?) where S.Iterator.Element == Iterator.Element?
    {
        guard let es = optionals?.flatMap( { $0 } ) else { return nil }
        
        self.init(es)
    }
}



public extension Collection where Index : Strideable
{
    /**
     Gets the element at the specified (optional) index, if it exists and is within the collections bounds.
     
     - parameter optionaleIndex: the optional index to look up
     - returns: the element at the index in `self`
     */
    func get(_ index: Index?) -> Generator.Element?
    {
        guard let index = index else { return nil }
        
        guard startIndex.distance(to:index) >= 0 else { return nil }
        
        guard index.distance(to:endIndex) > 0 else { return nil }
        
        return self[index]
    }

}
