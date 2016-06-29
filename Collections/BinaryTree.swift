//
//  BinaryTree.swift
//  Collections
//
//  Created by Christian Otkjær on 30/05/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

/// CAVEAT: Unfinished

public class TreeNode<T>
{
    public var value: T
    
    public var parent: TreeNode?
    public var children = [TreeNode<T>]()
    
    public init(value: T)
    {
        self.value = value
    }
    
    public func addChild(node: TreeNode<T>)
    {
        children.append(node)
        node.parent = self
    }
    
    public func addValueAsChild(value: T) -> TreeNode<T>
    {
        let node = TreeNode(value: value)
        
        children.append(node)
        node.parent = self
        
        return node
    }
}

public class Tree<T>
{
    private let root : TreeNode<T>
    
    init(root: TreeNode<T>)
    {
        self.root = root
    }
}

public class BinaryTree<T> : Tree<T>
{

}

public class BinarySearchTree<T>
{
    private let comparator : (T, T) -> Bool
    
    private(set) public var value: T
    
    private(set) public var parent: BinarySearchTree?
    
    private(set) public var left: BinarySearchTree?
    
    private(set) public var right: BinarySearchTree?
    
    public init(value: T, comparator: (T, T) -> Bool)
    {
        self.value = value
        self.comparator = comparator
    }

    private init(value: T, parent: BinarySearchTree<T>)
    {
        self.value = value
        self.parent = parent
        self.comparator = parent.comparator
    }

    
    public func insert(value: T) {
        insert(value, parent: self)
    }
    
    private func insert(value: T, parent: BinarySearchTree)
    {
        if comparator(value, self.value)
        {
            if let left = left
            {
                left.insert(value, parent: left)
            }
            else
            {
                left = BinarySearchTree(value: value, parent: parent)
            }
        }
        else
        {
            if let right = right
            {
                right.insert(value, parent: right)
            }
            else
            {
                right = BinarySearchTree(value: value, parent: parent)
            }
        }
    }
    
    func search()
    {
    }

}

