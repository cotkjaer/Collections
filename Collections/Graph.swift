//
//  Graph.swift
//  Collections
//
//  Created by Christian Otkjær on 26/05/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

open class Graph<Vertex: Hashable>
{
    typealias Edge = (neighbor: Vertex, weight: Int)
    
    fileprivate var edges = Dictionary<Vertex, Array<Edge>>()
    
    public init()
    {
        
    }
    
    public convenience init<S:Sequence>(vertices: S) where S.Iterator.Element == Vertex
    {
        self.init()
        
        vertices.forEach { add(vertex: $0) }
    }
    
    @discardableResult
    open func add(vertex: Vertex) -> Bool
    {
        guard edges[vertex] == nil else { return false }
        
        edges[vertex] = []
        
        return true
    }
    
    open func has(vertex: Vertex) -> Bool
    {
        return edges[vertex] != nil
    }
    
    func addEdgeWithWeight(_ weight: Int, fromVertex: Vertex, toVertex: Vertex)
    {
        add(vertex: fromVertex)
        add(vertex: toVertex)
        edges[fromVertex]?.append((toVertex, weight))
    }
    
    func edges(from vertex: Vertex) -> [Edge]
    {
        return edges[vertex] ?? []
    }

    func edges(from fromVertex: Vertex, to toVertex:Vertex) -> [Edge]
    {
        return (edges[fromVertex] ?? []).filter({ $0.neighbor == toVertex })
    }
    
    func neighborsTo(vertex: Vertex) -> [Vertex]
    {
        return edges(from: vertex).map({ $0.neighbor }).uniques()
    }

    var vertices : Array<Vertex>  { return Array(edges.keys) }
}

// MARK: -  CustomDebugStringConvertible, CustomStringConvertible

extension Graph : CustomDebugStringConvertible, CustomStringConvertible
{
    public var debugDescription : String
    {
        var d: String = ""
        
        for v in self.vertices
        {
            d += "\(v):\n"

            for e in edges(from: v)
            {
                d += "\(v) -\(e.weight)-> \(e.neighbor)\n"
            }
        }
        
        return d
    }
    
    public var description: String
    {
        return debugDescription
    }
}

// MARK: - Path

struct Path<Vertex>
{
    typealias Edge = (neighbor: Vertex, weight: Int)
    
    let total : Int
    let edges : [Edge]
    let origin : Vertex
    
    var destination: Vertex { return edges.last!.neighbor }
    
    fileprivate init(origin: Vertex, edge: Edge)
    {
        self.origin = origin
        total = edge.weight
        edges = [edge]
    }
    
    init(path: Path, edge: Edge)
    {
        origin = path.origin
        total = path.total + edge.weight
        edges = path.edges + [edge]
    }
}

// MARK: - CustomDebugStringConvertible

extension Path : CustomDebugStringConvertible, CustomStringConvertible
{
    var debugDescription : String
    {
        let edgeStrings = edges.map { " -\($0.weight)-> \($0.neighbor)" }
        
        let edgesString = edgeStrings.joined(separator: "")
        
        return "\(origin)\(edgesString)"
    }
    
    var description: String { return debugDescription }
}


// MARK: - Search

extension Graph
{
    /// Find a route from one vertex to another using a breadth first search
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The destination vertex.
    /// - returns: The shortest path from origin to destination, if one could be found, nil otherwise
    func shortestPathFrom(from origin: Vertex, to destination: Vertex) -> Path<Vertex>?
    {
        guard has(vertex: origin) else { return nil }

        guard has(vertex: destination) else { return nil }
        
        guard origin != destination else { return nil }
        
        var visited = [origin : true]

        var frontier: Heap<Path<Vertex>> = Heap(isOrderedBefore: {$0.total < $1.total})
        
        for edge in edges(from: origin)
        {
            frontier.push(Path(origin: origin, edge: edge))
        }
        
        while let shortestPath = frontier.pop()
        {
            if shortestPath.destination == destination { return shortestPath }
            
            visited[shortestPath.destination] = true
            
            for edge in edges(from : shortestPath.destination).filter({ visited[$0.neighbor] == nil })
            {
                frontier.push(Path(path: shortestPath, edge: edge))
            }
        }
        
        return nil
    }
}


/*

class Vertex<T>
{
    var value: T
    var edges: Array<Edge<T>>
    
    init(value: T)
    {
        self.value = value
        edges = Array<Edge<T>>()
    }
    
    func addEdge(edge: Edge<T>)
    {
        edges.append(edge)
    }
    
    func addEdgeToVertex(vertex: Vertex<T>, weight: Int)
    {
        addEdge(Edge(to: vertex, weight: weight))
    }
}

class Edge<T>
{
    var to: Vertex<T>
    var weight: Int
    
    init(to vertex: Vertex<T>, weight w: Int = 0)
    {
        weight = w
        to = vertex
    }
}

class Graph<T>
{
    private var vertices = Array<Vertex<T>>()
    
    let isDirected: Bool
    
    init(directed: Bool = true)
    {
        isDirected = directed
    }
    
    //create a new vertex
    func addVertex(value: T) -> Vertex<T>
    {
        let vertex = Vertex(value: value)
        
        vertices.append(vertex)
        
        return vertex
    }
    
    func addEdge(from fromVertex: Vertex<T>, to toVertex: Vertex<T>, weight: Int)
    {
        fromVertex.addEdgeToVertex(toVertex, weight: weight)
        
        // TODO: Check if both fromVertex and toVertex are in the array of vertices
        
        //check for undirected graph
        
        if (isDirected == false)
        {
            toVertex.addEdgeToVertex(fromVertex, weight: weight)
        }
    }
}

// MARK: - Shrotest Path

extension Graph where T : Equatable
{
    //process Dijkstra's shortest path algorithm
    
    func shortestPathFrom(source: Vertex<T>, to destination: Vertex<T>) -> Path<T>?
    {
        var finalPaths: Heap<Path<T>> = Heap(isOrderedBefore: {$0.total < $1.total})
        
        
        var frontier: Heap<Path<T>> = Heap(isOrderedBefore: {$0.total < $1.total})
        
        for edge in source.edges
        {
            let newPath: Path = Path(total: edge.weight, destination: edge.to, previous: nil)
            
            frontier.push(newPath)
        }
        
        while let shortestPath = frontier.pop()
        {
            for edge in shortestPath.destination.edges
            {
                let newPath: Path = Path(total: shortestPath.total + edge.weight, destination: edge.to, previous: shortestPath)
                
                frontier.push(newPath)
            }
            
            if shortestPath.destination.value == destination.value
            {
                finalPaths.push(shortestPath)
            }
        }
        
        return finalPaths.pop()
    }
}

class Path<T>
{
    var total: Int = 0
    var destination: Vertex<T>
    var previous: Path<T>?
    
    init(total: Int = 0, destination: Vertex<T>, previous: Path<T>? = nil)
    {
        self.total = total
        self.destination = destination
        self.previous = previous
    }
}


// MARK: - CustomDebugStringConvertible

extension Path : CustomDebugStringConvertible
{
    var vertices : Array<Vertex<T>>
    {
        var rest = previous?.vertices ?? []
        
        rest.append(destination)
        
        return rest
    }
    
    var debugDescription : String { return "Path(total: \(total), vertices: \(vertices))" }
}
*/
