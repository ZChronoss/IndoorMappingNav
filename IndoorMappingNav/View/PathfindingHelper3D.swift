//
//  PathfindingHelper3D.swift
//  IndoorMappingNav
//
//  Created by Leonardo Marhan on 04/10/24.
//

import GameplayKit

class PathfindingHelper3D {
    var graph = GKGraph()
    var intersectionNodes: [GKGraphNode3D] = []

    // Adds a node at a given position and type (intersection or store)
    func addNode(at position: SCNVector3, type: NodeType) -> GKGraphNode3D {
        let node = GKGraphNode3D(point: vector_float3(position.x, position.y, position.z))
        graph.add([node])
        
        if type == .intersection {
            intersectionNodes.append(node)
        }
        
//        print("NODE: \(node)")
        return node
    }

    // Connects nodes bidirectionally in sequence
    func connectNodes(_ nodes: [GKGraphNode3D], maxConnections: Int = 5) {
        for currentNode in nodes {
            var nearestNodes: [(GKGraphNode3D, Float)] = []

            // Find the nearest nodes by their position
            for otherNode in nodes where currentNode !== otherNode {
                let distance = simd_distance(currentNode.position, otherNode.position)
                nearestNodes.append((otherNode, distance))
            }

            // Sort the nodes by distance (nearest first)
            nearestNodes.sort { $0.1 < $1.1 }

            // Connect to the nearest `maxConnections` nodes
            let nearestConnections = nearestNodes.prefix(maxConnections).map { $0.0 }
            currentNode.addConnections(to: nearestConnections, bidirectional: true)
        }
    }


    // Finds the path between the start and end nodes
    func findPath(from startNode: GKGraphNode3D, to endNode: GKGraphNode3D) -> [GKGraphNode3D]? {
        print("Finding path from \(startNode.position) to \(endNode.position)")
        
        let path = graph.findPath(from: startNode, to: endNode) as? [GKGraphNode3D]
        
        if let path = path {
            print("Path found with \(path.count) nodes")
        } else {
            print("No path found")
        }
        
        return path
    }

    // Finds the nearest graph node to a given position
    func findNearestNode(to position: SCNVector3) -> GKGraphNode3D? {
        let targetPoint = vector_float3(position.x, position.y, position.z)
        
        let nearestNode = intersectionNodes.min(by: {
            simd_distance($0.position, targetPoint) < simd_distance($1.position, targetPoint)
        })
        
        return nearestNode
    }
}
