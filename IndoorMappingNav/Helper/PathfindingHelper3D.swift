//
//  PathfindingHelper3D.swift
//  IndoorMappingNav
//
//  Created by Leonardo Marhan on 04/10/24.
//

import GameplayKit

class PathfindingHelper3D {
    var pathGraph = GKGraph()
    var interGraph = GKGraph()
    var pathNodes: [GKGraphNode3D] = []
    var interNodes: [GKGraphNode3D] = []

    // Adds a node at a given position and type (intersection or store)
    func addNode(at position: SCNVector3, type: NodeType) -> GKGraphNode3D {
        let node = GKGraphNode3D(point: vector_float3(position.x, position.y, position.z))
        
        if type == .path {
            pathNodes.append(node)
            pathGraph.add([node])
        }
        else if type == .intersection {
            interNodes.append(node)
            interGraph.add([node])
        }
        
//        print("NODE: \(node)")
        return node
    }

    // Connects nodes bidirectionally in sequence
    func connectNodes(_ nodes: [GKGraphNode3D], maxConnections: Int = 4) {
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
    func findPath(from startNode: GKGraphNode3D, to endNode: GKGraphNode3D, type: NodeType) -> [GKGraphNode3D]? {
        
        var path: [GKGraphNode3D]?
        
        if type == .path {
            path = pathGraph.findPath(from: startNode, to: endNode) as? [GKGraphNode3D]
        }
        else if type == .intersection {
            path = interGraph.findPath(from: startNode, to: endNode) as? [GKGraphNode3D]
        }
        
        return path
    }

    // Finds the nearest graph node to a given position
    func findNearestNode(to position: SCNVector3, type: NodeType) -> GKGraphNode3D? {
        let targetPoint = vector_float3(position.x, position.y, position.z)
        
        var nearestNode: GKGraphNode3D?
        if type == .path {
            nearestNode = pathNodes.min(by: {
                simd_distance($0.position, targetPoint) < simd_distance($1.position, targetPoint)
            })
        }
        else if type == .intersection {
            nearestNode = interNodes.min(by: {
                simd_distance($0.position, targetPoint) < simd_distance($1.position, targetPoint)
            })
        }
        
        return nearestNode
    }
}
