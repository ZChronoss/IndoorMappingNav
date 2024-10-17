//
//  PathfindingService.swift
//  IndoorMappingNav
//
//  Created by Leonardo Marhan on 14/10/24.
//

import RealityKit
import GameplayKit

enum NodeType {
    case store
    case intersection
}

class PathfindingService {
    var pathfinder = PathfindingHelper3D()
    var pathEntities: [Entity] = []
    var scene: Entity? = nil
    
    func startNavigation(start: String, end: String) {
        print("Scene when starting navigation: \(scene?.name ?? "nil")")
        do {
            guard let scene = scene else {
                print("Scene is not available.")
                return
            }
            
            if let startEntity = scene.findEntity(named: start),
               let endEntity = scene.findEntity(named: end) {
                let startPosition = startEntity.position(relativeTo: scene)
                let endPosition = endEntity.position(relativeTo: scene)
                
                print("Navigation from \(start) to \(end)")
                drawPathBetweenNodes(from: startPosition, to: endPosition)
            }
            else {
                print("Could not find start or end node: \(start) or \(end).")
            }
        }
    }
    
    func setupPath(loadedScene: Entity) {
        scene = loadedScene
        print("Scene set up with: \(scene?.name ?? "nil")")
        setupCollision()
        
        // Get the ground plane's size and position
        let groundBounds = loadedScene.visualBounds
        let groundSizeX = groundBounds.extents.x
        let groundSizeZ = groundBounds.extents.z
        
        print(groundBounds)
        print(groundSizeX)
        print(groundSizeZ)
        
        let groundPosition = loadedScene.position(relativeTo: nil)
        
        print(groundPosition)
        
        let gridSpacing: Float = 0.12
        
        var pathNodes: [GKGraphNode3D] = []
        
        for x in stride(from: -groundSizeX, through: groundSizeX / 2, by: gridSpacing) {
            for z in stride(from: -groundSizeZ / 2, through: groundSizeZ / 2, by: gridSpacing) {
                let nodePosition = SCNVector3(
                    groundPosition.x + x,
                    groundPosition.y,
                    groundPosition.z + z
                )
                
//                                let markerPosition = SCNVector3(
//                                    groundPosition.x + x,
//                                    0.5,  // Slightly above the ground plane
//                                    groundPosition.z + z
//                                )
                
                if checkForPath(at: simd_float3(nodePosition)) {
                    let pathNode = pathfinder.addNode(at: nodePosition, type: .intersection)
//                                        let marker = createMarkerEntity(at: simd_float3(markerPosition), color: .blue)
//                                        loadedScene.addChild(marker)
                    pathNodes.append(pathNode)
                }
            }
        }
        
        print("Base graph is going to setup with \(pathNodes.count) nodes.")
        pathfinder.connectNodes(pathNodes)
        print("Base graph setup with \(pathNodes.count) nodes.")
    }
    
    func interpolateCatmullRom(points: [simd_float3], segments: Int) -> [simd_float3] {
        var result: [simd_float3] = []
        
        for i in 0..<points.count - 3 {
            let p0 = points[i]
            let p1 = points[i + 1]
            let p2 = points[i + 2]
            let p3 = points[i + 3]
            
            for t in 0...segments {
                let tFloat = Float(t) / Float(segments)
                let t2 = tFloat * tFloat
                let t3 = t2 * tFloat
                
                // Catmull-Rom spline formula
                let x = 0.5 * ((2.0 * p1.x) +
                               (-p0.x + p2.x) * tFloat +
                               (2.0 * p0.x - 5.0 * p1.x + 4.0 * p2.x - p3.x) * t2 +
                               (-p0.x + 3.0 * p1.x - 3.0 * p2.x + p3.x) * t3)
                
                let y = 0.5 * ((2.0 * p1.y) +
                               (-p0.y + p2.y) * tFloat +
                               (2.0 * p0.y - 5.0 * p1.y + 4.0 * p2.y - p3.y) * t2 +
                               (-p0.y + 3.0 * p1.y - 3.0 * p2.y + p3.y) * t3)
                
                let z = 0.5 * ((2.0 * p1.z) +
                               (-p0.z + p2.z) * tFloat +
                               (2.0 * p0.z - 5.0 * p1.z + 4.0 * p2.z - p3.z) * t2 +
                               (-p0.z + 3.0 * p1.z - 3.0 * p2.z + p3.z) * t3)
                
                result.append(simd_float3(x, y, z))
            }
        }
        
        return result
    }
    
    func drawPathBetweenNodes(from start: simd_float3, to end: simd_float3) {
        pathEntities.forEach { $0.removeFromParent() }
        pathEntities.removeAll()

        let startNode = pathfinder.addNode(at: SCNVector3(start.x, start.y, start.z), type: .store)
        let endNode = pathfinder.addNode(at: SCNVector3(end.x, end.y, end.z), type: .store)

        if let nearestStartNode = pathfinder.findNearestNode(to: SCNVector3(start.x, start.y, start.z)),
           let nearestEndNode = pathfinder.findNearestNode(to: SCNVector3(end.x, end.y, end.z)) {

            startNode.addConnections(to: [nearestStartNode], bidirectional: true)
            endNode.addConnections(to: [nearestEndNode], bidirectional: true)
        }

        let debugSphere = createMarkerEntity(at: startNode.position)
        scene?.addChild(debugSphere)

        // Find the path using GameplayKit
        if let path = pathfinder.findPath(from: startNode, to: endNode) {
            var pathPositions: [simd_float3] = path.map { simd_float3($0.position) }
            
            // Insert first and last positions as control points for smoothing
            pathPositions.insert(pathPositions.first!, at: 0)
            pathPositions.append(pathPositions.last!)
            
            // Get the smooth path using Catmull-Rom interpolation
            let smoothPath = interpolateCatmullRom(points: pathPositions, segments: 20)
            
            var index = 0
            let stepDuration = 0.01
            
            Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
                if index >= smoothPath.count - 1 {
                    timer.invalidate() // Stop the timer when all nodes are visited
                    return
                }

                let startPos = smoothPath[index]
                let endPos = smoothPath[index + 1]
                index += 1

                self.showDirection(from: startPos, to: endPos)

                // Create the line entity and add it to the scene
                let lineEntity = self.createLineEntity(from: startPos, to: endPos)
                self.pathEntities.append(lineEntity)
                self.scene?.addChild(lineEntity)

                // Move the debug sphere to follow the path
                debugSphere.position = endPos

                // Print the position of the sphere for debugging
//                print("Sphere position: \(debugSphere.position)")
            }
        }
    }

    func showDirection(from startPos: simd_float3, to endPos: simd_float3) {
        var directionOutput: String
        let direction = normalize(endPos - startPos)
        let referenceDirection = simd_float3(0, 1, 0)
        let crossProduct = simd_cross(direction, referenceDirection)
        
        // Detect dominant axis of movement
        if abs(direction.x) > abs(direction.z) {
            if crossProduct.x > 0 {
                directionOutput = "Right"
            } else if crossProduct.x < 0 {
                directionOutput = "Left"
            } else {
                directionOutput = "Straight"
            }
        } else {
            if crossProduct.z < 0 {
                directionOutput = "Right"
            } else if crossProduct.z > 0 {
                directionOutput = "Left"
            } else {
                directionOutput = "Straight"
            }
        }
        print(directionOutput)
    }

    // MARK: - RealityKit Entity Creation for Path Segments
    func createLineEntity(from start: simd_float3, to end: simd_float3) -> Entity {
        let lineLength = simd_distance(start, end)
        let line = MeshResource.generateBox(size: [0.05, 0.05, lineLength])
        
        let material = SimpleMaterial(color: .blue, isMetallic: false)
        let lineEntity = ModelEntity(mesh: line, materials: [material])
        
        lineEntity.position = (start + end) / 2
        lineEntity.look(at: end, from: lineEntity.position, relativeTo: nil)
        
        return lineEntity
    }
    
    // MARK: - Collision Check Function
    func checkForPath(at position: simd_float3) -> Bool {
        guard let scene = scene else { return false }
        
        let pathEntities = scene.findPath()
        guard !pathEntities.isEmpty else {
            print("No path found.")
            return false
        }
        
        for path in pathEntities {
            if isPointInsideBoundingBox(position, boundingBox: path.visualBounds(relativeTo: scene)) {
                print("Collision detected at position \(position) within \(path.name).")
                return true
            }
        }
        return false
    }
    
    func addCollisionComponent(to entity: Entity) {
        let collisionShape = ShapeResource.generateBox(size: entity.visualBounds.extents)
        entity.components.set(CollisionComponent(shapes: [collisionShape]))
    }
    
    func setupCollision() {
        if let sceneEntities = scene?.findAllEntities() {
            for entity in sceneEntities {
                entity.components.remove(CollisionComponent.self)
            }
        }
        
        let pathEntities = scene?.findPath() ?? []
        for pathEntity in pathEntities {
            addCollisionComponent(to: pathEntity)
        }
    }
    
    func createMarkerEntity(at position: simd_float3, color: UIColor = .red) -> Entity {
        let markerMesh = MeshResource.generateSphere(radius: 0.05)
        let markerMaterial = SimpleMaterial(color: color, isMetallic: false)
        let markerEntity = ModelEntity(mesh: markerMesh, materials: [markerMaterial])
        markerEntity.position = position
        
        return markerEntity
    }
    
    func isPointInsideBoundingBox(_ point: simd_float3, boundingBox: BoundingBox) -> Bool {
        return (point.x >= boundingBox.min.x && point.x <= boundingBox.max.x) &&
        (point.z >= boundingBox.min.z && point.z <= boundingBox.max.z)
    }
    
}

// Helper to convert SCNVector3 to simd_float3
extension simd_float3 {
    init(_ scnVector: SCNVector3) {
        self.init(scnVector.x, scnVector.y, scnVector.z)
    }
}


extension Entity {
    var visualBounds: BoundingBox {
        return self.visualBounds(relativeTo: self)
    }
    
    func findEntity(named name: String) -> Entity? {
        if self.name == name {
            return self
        }
        
        for child in children {
            if let found = child.findEntity(named: name) {
                return found
            }
        }
        
        return nil
    }
    
    func findPath() -> [Entity] {
        var path: [Entity] = []
        
        if self.name.contains("pwy_") {
            path.append(self)
        }
        
        for child in children {
            path.append(contentsOf: child.findPath())
        }
        
        return path
    }
    
    func findAllEntities(excluding entityName: String = "pwy_") -> [Entity] {
        var allEntities: [Entity] = []
        
        if !self.name.contains(entityName) {
            allEntities.append(self)
        }
        
        for child in children {
            allEntities.append(contentsOf: child.findAllEntities(excluding: entityName))
        }
        
        return allEntities
    }
}
