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
    case path
    case intersection
}

class PathfindingService: ObservableObject {
    static let shared = PathfindingService()
    var pathfinder = PathfindingHelper3D()
    var pathEntities: [Entity] = []
    var interEntities: [Entity] = []
    var pathNodes: [GKGraphNode3D] = []
    var interNodes: [GKGraphNode3D] = []
    var instructions: [Directions] = []
    var pathCounts: Float = 0
    var scene: Entity? = nil
    var cameraEntity: Entity?
    
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
        
        
        
        for x in stride(from: -groundSizeX, through: groundSizeX / 2, by: gridSpacing) {
            for z in stride(from: -groundSizeZ / 2, through: groundSizeZ / 2, by: gridSpacing) {
                let nodePosition = SCNVector3(
                    groundPosition.x + x,
                    groundPosition.y,
                    groundPosition.z + z
                )
                
                //                                                let markerPosition = SCNVector3(
                //                                                    groundPosition.x + x,
                //                                                    0.5,  // Slightly above the ground plane
                //                                                    groundPosition.z + z
                //                                                )
                
                if checkForPath(at: simd_float3(nodePosition), type: .path) {
                    let pathNode = pathfinder.addNode(at: nodePosition, type: .path)
                    //                    let marker = createMarkerEntity(at: simd_float3(markerPosition), color: .yellow)
                    //                                                            loadedScene.addChild(marker)
                    pathNodes.append(pathNode)
                }
                
                if checkForPath(at: simd_float3(nodePosition), type: .intersection) {
                    let interNode = pathfinder.addNode(at: nodePosition, type: .intersection)
                    //                                                            let marker = createMarkerEntity(at: simd_float3(markerPosition), color: .blue)
                    //                                                            loadedScene.addChild(marker)
                    interNodes.append(interNode)
                }
            }
            
        }
        pathfinder.connectNodes(pathNodes)
        pathfinder.connectNodes(interNodes)
        print("Base graph setup with \(pathNodes.count) path nodes & \(interNodes.count) inter nodes.")
        setupCamera()
    }
    
    func setupCamera() {
        if let existingCamera = cameraEntity {
            existingCamera.removeFromParent()
        }
        //        guard let cameraEntity = cameraEntity else { return }
        
        let cameraPosition = simd_float3(1, 1, 1)
        let cameraLookAt = simd_float3(0, 0, 0)
        
        let cameraAnchor = AnchorEntity(world: cameraPosition)
        let perspectiveCameraComponent = PerspectiveCameraComponent()
        
        let newCameraEntity = Entity()
        newCameraEntity.components[PerspectiveCameraComponent.self] = perspectiveCameraComponent
        newCameraEntity.look(at: cameraLookAt, from: cameraPosition, relativeTo: nil)
        
        scene?.addChild(cameraAnchor)
        cameraAnchor.addChild(newCameraEntity)
        
        cameraEntity = newCameraEntity
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
        interEntities.forEach { $0.removeFromParent() }
        interEntities.removeAll()
        
        var pathPositions: [simd_float3] = []
        
        let startNode = pathfinder.addNode(at: SCNVector3(start.x, start.y, start.z), type: .store)
        let endNode = pathfinder.addNode(at: SCNVector3(end.x, end.y, end.z), type: .store)
        
        let pathSphere = createMarkerEntity(at: startNode.position)
        scene?.addChild(pathSphere)
        
        if let nearestStartNode = pathfinder.findNearestNode(to: SCNVector3(start.x, start.y, start.z), type: .path),
           let nearestEndNode = pathfinder.findNearestNode(to: SCNVector3(end.x, end.y, end.z), type: .path) {
            startNode.addConnections(to: [nearestStartNode], bidirectional: true)
            endNode.addConnections(to: [nearestEndNode], bidirectional: true)
            
            // Find the path using GameplayKit
            if let path = pathfinder.findPath(from: startNode, to: endNode, type: .path) {
                pathPositions = path.map { simd_float3($0.position) }
                print("PATH===",pathPositions.count)
                
                //                for i in 0..<pathPositions.count {
                //                    let debug = createMarkerEntity(at: pathPositions[i], color: .black)
                //                    scene?.addChild(debug)
                //                }
                
                // Insert first and last positions as control points for smoothing
                guard let firstPosition = pathPositions.first,
                      let lastPosition = pathPositions.last else {
                    return
                }
                
                pathPositions.insert(firstPosition, at: 0)
                pathPositions.append(lastPosition)
                
                let smoothPath = interpolateCatmullRom(points: pathPositions, segments: 20)
                pathCounts = Float(smoothPath.count)
                
                for i in 0..<smoothPath.count - 1 {
                    let startPos = smoothPath[i]
                    let endPos = smoothPath[i + 1]
                    let fullPathLineEntity = createLineEntity(from: startPos, to: endPos, opacity: 0.3)
                    
                    pathEntities.append(fullPathLineEntity)
                    scene?.addChild(fullPathLineEntity)
                }
                
                var animatedIndex = 0
                let stepDuration = 0.000001
                
                Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
                    if animatedIndex >= smoothPath.count - 1 {
                        timer.invalidate()
                        return
                    }
                    
                    let animatedStartPos = smoothPath[animatedIndex]
                    let animatedEndPos = smoothPath[animatedIndex + 1]
                    animatedIndex += 1
                    
                    let animatedLineEntity = self.createLineEntity(from: animatedStartPos, to: animatedEndPos, opacity: 1.0)
                    self.scene?.addChild(animatedLineEntity)
                    
                    pathSphere.position = animatedEndPos
                }
            }
        }
        
        if let nearestStartNode = pathfinder.findNearestNode(to: SCNVector3(start.x, start.y, start.z), type: .intersection) {
            for i in 0..<interNodes.count - 1 {
                
                let startPos = interNodes[i]
                
                for j in 0..<pathPositions.count {
                    if startPos.position == pathPositions[j] {
                        print("GOT INTERPOSITION", pathPositions[j])
                        let intersectionEntity = createMarkerEntity(at: simd_float3(startPos.position.x, -0.1, startPos.position.z), color: .clear)
                        
                        interEntities.append(intersectionEntity)
                        scene?.addChild(intersectionEntity)
                    }
                }
            }
            interEntities.sort { (entity1, entity2) -> Bool in
                let pos1 = entity1.position
                let pos2 = entity2.position
                let dist1 = distance(simd_float3(nearestStartNode.position), simd_float3(pos1))
                let dist2 = distance(simd_float3(nearestStartNode.position), simd_float3(pos2))
                return dist1 < dist2
            }
        }
        
        saveDirection()
    }
    
    func saveDirection() {
        var lastDirection: Directions? = nil
        var removedInter: [Int] = []
        instructions.removeAll()
        func determineDirection(from start: simd_float3, to end: simd_float3) -> Directions? {
            let storeName = findClosestEntity(from: end)?.name ?? ""
            let movementDirection = normalize(end - start)
            
            // Calculate the facing angle in radians
            let facingAngle = atan2(movementDirection.x, movementDirection.z)
            
            // Determine the reference direction based on the facing angle
            let referenceDirection: simd_float3
            switch facingAngle {
            case (-.pi / 4)...(.pi / 4):
                // Facing close to negative z-axis (forward)
                referenceDirection = simd_float3(0, 0, -1)
            case (.pi / 4)...(3 * .pi / 4):
                // Facing close to negative x-axis (left)
                referenceDirection = simd_float3(1, 0, 0)
            case (-3 * .pi / 4)...(-.pi / 4):
                // Facing close to positive x-axis (right)
                referenceDirection = simd_float3(-1, 0, 0)
            default:
                // Facing close to positive z-axis (backward)
                referenceDirection = simd_float3(0, 0, 1)
            }
            
            // Calculate cross product in the x-z plane
            let crossProduct = simd_cross(referenceDirection, movementDirection)
            
            // Determine direction based on the cross product's y-component
            if crossProduct.y > 0 {
                return RightDirection(store: storeName)
            } else if crossProduct.y < 0 {
                return LeftDirection(store: storeName)
            } else {
                return StraightDirection(store: storeName)
            }
        }

        for i in 0..<interEntities.count {
            let startPos = interEntities[i].position
            let endPos = (i == interEntities.count - 1) ? pathEntities.last!.position : interEntities[i + 1].position
            
            guard let currentDirection = determineDirection(from: startPos, to: endPos) else { continue }
            if currentDirection is StraightDirection, lastDirection is StraightDirection {
                removedInter.append(i)
            }
            lastDirection = currentDirection
            
            let nextPos = (i >= interEntities.count - 2) ? pathEntities.last!.position : interEntities[i + 2].position
            if let nextDirection = determineDirection(from: endPos, to: nextPos),
               currentDirection is StraightDirection, nextDirection is StraightDirection {
                continue
            }
            instructions.append(currentDirection)
        }
        
        for index in removedInter.reversed() {
            interEntities.remove(at: index)
        }
    }
    
    
    // MARK: - RealityKit Entity Creation for Path Segments
    func createLineEntity(from start: simd_float3, to end: simd_float3, opacity: Float) -> Entity {
        let lineLength = simd_distance(start, end)
        let line = MeshResource.generateBox(size: [0.05, 0.05, lineLength])
        
        let material = SimpleMaterial(color: .blue.withAlphaComponent(CGFloat(opacity)), isMetallic: false)
        let lineEntity = ModelEntity(mesh: line, materials: [material])
        
        lineEntity.position = (start + end) / 2
        lineEntity.look(at: end, from: lineEntity.position, relativeTo: nil)
        
        return lineEntity
    }
    
    // MARK: - Collision Check Function
    func checkForPath(at position: simd_float3, type: NodeType) -> Bool {
        guard let scene = scene else { return false }
        
        var entities: [Entity] = []
        if type == .path {
            entities = scene.findPath()
        }
        else if type == .intersection {
            entities = scene.findIntersection()
        }
        guard !entities.isEmpty else {
            print("No path found.")
            return false
        }
        
        for path in entities {
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
            print("ALL", sceneEntities)
            for entity in sceneEntities {
                entity.components.remove(CollisionComponent.self)
            }
        }
        
        let pathEntities = scene?.findPath() ?? []
        for pathEntity in pathEntities {
            addCollisionComponent(to: pathEntity)
        }
        
        let interEntities = scene?.findIntersection() ?? []
        for interEntity in interEntities {
            addCollisionComponent(to: interEntity)
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
    
    func findClosestEntity(from position: simd_float3) -> Entity? {
        guard let scene = scene else { return nil }
        let validEntities = scene.findAllEntities()
        
        var closestEntity: Entity? = nil
        var closestDistance: Float = .infinity
        
        for entity in validEntities {
            if !entity.name.isEmpty {
                let distance = simd_distance(entity.position, position)
                
                if distance < closestDistance {
                    closestDistance = distance
                    closestEntity = entity
                }
            }
            
        }
        
        return closestEntity
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
    
    func findIntersection() -> [Entity] {
        var inter: [Entity] = []
        
        if self.name.contains("PSP") {
            inter.append(self)
        }
        
        for child in children {
            inter.append(contentsOf: child.findIntersection())
        }
        
        return inter
    }
    
    func findAllEntities(excluding nameFragments: [String] = ["pwy_", "PSP", "Based"]) -> [Entity] {
        var allEntities: [Entity] = []
        
        let containsName = nameFragments.contains { self.name.contains($0) }
        if !containsName {
            allEntities.append(self)
        }
        
        for child in children {
            allEntities.append(contentsOf: child.findAllEntities(excluding: nameFragments))
        }
        
        return allEntities
    }
}
