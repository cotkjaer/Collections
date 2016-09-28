//
//  BinaryTree.swift
//  Collections
//
//  Created by Christian Otkjær on 30/05/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

/// CAVEAT: Unfinished

open class TreeNode<T>
{
    open var value: T
    
    open var parent: TreeNode?
    open var children = [TreeNode<T>]()
    
    public init(value: T)
    {
        self.value = value
    }
    
    open func addChild(_ node: TreeNode<T>)
    {
        children.append(node)
        node.parent = self
    }
    
    open func addValueAsChild(_ value: T) -> TreeNode<T>
    {
        let node = TreeNode(value: value)
        
        children.append(node)
        node.parent = self
        
        return node
    }
}

open class Tree<T>
{
    fileprivate let root : TreeNode<T>
    
    init(root: TreeNode<T>)
    {
        self.root = root
    }
}

open class BinaryTree<T> : Tree<T>
{

}

open class BinarySearchTree<T>
{
    fileprivate let comparator : (T, T) -> Bool
    
    fileprivate(set) open var value: T
    
    fileprivate(set) open var parent: BinarySearchTree?
    
    fileprivate(set) open var left: BinarySearchTree?
    
    fileprivate(set) open var right: BinarySearchTree?
    
    public init(value: T, comparator: @escaping (T, T) -> Bool)
    {
        self.value = value
        self.comparator = comparator
    }

    fileprivate init(value: T, parent: BinarySearchTree<T>)
    {
        self.value = value
        self.parent = parent
        self.comparator = parent.comparator
    }

    
    open func insert(_ value: T) {
        insert(value, parent: self)
    }
    
    fileprivate func insert(_ value: T, parent: BinarySearchTree)
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

