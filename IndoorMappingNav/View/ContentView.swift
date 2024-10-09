import SwiftUI
import RealityKit
import GameplayKit
import MallMap

enum NodeType {
    case store
    case intersection
}

struct ContentView: View {
    var pathfinder = PathfindingHelper3D()
    var scaleNum: Float = 0.05
    var positionScale: Float = 1.0 / 0.05
    
    @State private var scene: Entity? = nil
    @State private var pathEntities: [Entity] = []
    
    //debug
    //    @State private var markerEntities: [Entity] = []  // Track marker entities
    
    
    var body: some View {
        VStack {
            Text("RealityKit Pathfinding")
                .font(.title)
                .padding()
            
            RealityView { content in
                if let loadedScene = try? await Entity(named: "Untitled Scene", in: mallMapBundle) {
                    loadedScene.transform.scale = [scaleNum, scaleNum, scaleNum]
                    scene = loadedScene
                    content.add(scene!)
                    setupScene()
                    setupBaseGraph()
                    startNavigation()
                }
            } update: { content in }
                .gesture(
                    SpatialTapGesture()
                        .targetedToAnyEntity()
                        .onEnded ({ target in
//                            let startPosition = findEntities(named: "Star")
                            
//                            let endPosition = simd_float3(startPosition.x - 10, startPosition.y, startPosition.z - 10)
//                            print(endPosition)
//                            
//                            drawPathBetweenNodes(from: startPosition, to: endPosition)
                        })
                )
                .realityViewCameraControls(.orbit)
        }
    }
    func startNavigation() {
        let startPosition = (scene?.findEntities(named: "Tawan")?.position(relativeTo: scene))!
        let endPosition = (scene?.findEntities(named: "Proma__022")?.position(relativeTo: scene))!
        
        drawPathBetweenNodes(from: startPosition, to: endPosition)
    }
    
    func setupBaseGraph() {
        guard let scene = scene else { return }
        
        // Get the ground plane's size and position
        let groundBounds = scene.visualBounds(relativeTo: scene)
        let groundSizeX = groundBounds.extents.x
        let groundSizeZ = groundBounds.extents.z
        
        print(groundBounds)
        print(groundSizeX)
        print(groundSizeZ)
        
        let groundPosition = scene.position(relativeTo: nil)
        
        print(groundPosition)
        
        let gridSpacing: Float = 5.0
        
        var pathNodes: [GKGraphNode3D] = []
        
        for x in stride(from: -groundSizeX, through: groundSizeX / 2, by: gridSpacing) {
            for z in stride(from: -groundSizeZ / 2, through: groundSizeZ / 2, by: gridSpacing) {
                let nodePosition = SCNVector3(
                    groundPosition.x + x,
                    -9,  // Slightly above the ground plane
                    groundPosition.z + z
                )
                
                let markerPosition = SCNVector3(
                    groundPosition.x + x,
                    0,  // Slightly above the ground plane
                    groundPosition.z + z
                )
                
                // Check for collisions before adding a node
                if !checkCollision(at: simd_float3(nodePosition)) && isPointInsideBoundingBox(simd_float3(nodePosition), boundingBox: scene.visualBounds(relativeTo: scene)) {
                    let pathNode = pathfinder.addNode(at: nodePosition, type: .intersection)
                    let marker = createMarkerEntity(at: simd_float3(markerPosition), color: .blue)
                    scene.addChild(marker)
                    pathNodes.append(pathNode)
                    //                    print("Added node at position \(nodePosition).")
                }
            }
        }
        
        print("Base graph is going to setup with \(pathNodes.count) nodes.")
        pathfinder.connectNodes(pathNodes)
        print("Base graph setup with \(pathNodes.count) nodes.")
    }
    
    
    func drawPathBetweenNodes(from start: simd_float3, to end: simd_float3) {
        pathEntities.forEach { $0.removeFromParent() }
        pathEntities.removeAll()
        
        let startNode = pathfinder.addNode(at: SCNVector3(start.x, -10, start.z), type: .store)
        let endNode = pathfinder.addNode(at: SCNVector3(end.x, -10, end.z), type: .store)
        
        if let nearestStartNode = pathfinder.findNearestNode(to: SCNVector3(start.x, start.y, start.z)),
           let nearestEndNode = pathfinder.findNearestNode(to: SCNVector3(end.x, end.y, end.z)) {
            
            startNode.addConnections(to: [nearestStartNode], bidirectional: true)
            endNode.addConnections(to: [nearestEndNode], bidirectional: true)
        }
        
        // Find the path using GameplayKit
        if let path = pathfinder.findPath(from: startNode, to: endNode) {
            for i in 0..<path.count - 1 {
                let nodeA = path[i]
                let nodeB = path[i+1]
                
                let startPos = simd_float3(nodeA.position)
                let endPos = simd_float3(nodeB.position)
                
                let lineEntity = createLineEntity(from: startPos, to: endPos)
                pathEntities.append(lineEntity)
                scene?.addChild(lineEntity)
            }
        }
    }
    
    // MARK: - RealityKit Entity Creation for Path Segments
    func createLineEntity(from start: simd_float3, to end: simd_float3) -> Entity {
        let lineLength = simd_distance(start, end)
        let line = MeshResource.generateBox(size: [0.5, 0.5, lineLength])
        
        let material = SimpleMaterial(color: .blue, isMetallic: false)
        let lineEntity = ModelEntity(mesh: line, materials: [material])
        
        lineEntity.position = (start + end) / 2
        lineEntity.look(at: end, from: lineEntity.position, relativeTo: nil)
        
        return lineEntity
    }
    
    // MARK: - Collision Check Function
    func checkCollision(at position: simd_float3) -> Bool {
        guard let scene = scene else { return false }
        for entity in scene.findAllEntities() {
            if entity.name.contains("Mapping") || entity.name == "Root" {
                continue
            }
            
            let boundingBox = entity.visualBounds(relativeTo: scene)
            
            if isPointInsideBoundingBox(position, boundingBox: boundingBox) {
                print("Collision detected at position \(position) with entity \(entity.name).")
                return true
            }
        }
        return false
    }
    
    func addCollisionComponent(to entity: Entity) {
        let collisionShape = ShapeResource.generateBox(size: entity.visualBounds.extents)
        entity.components.set(CollisionComponent(shapes: [collisionShape]))
    }
    
    func setupScene() {
        //        clearMarkers()
        //        print("setupSCENE")
        if let sceneEntities = scene?.findAllEntities() {
            for entity in sceneEntities {
                addCollisionComponent(to: entity)
//                                entity.components.remove(CollisionComponent.self)
            }
        }
    }
    
    

    func createMarkerEntity(at position: simd_float3, color: UIColor = .red) -> Entity {
        let markerMesh = MeshResource.generateSphere(radius: 0.5)
        let markerMaterial = SimpleMaterial(color: color, isMetallic: false)
        let markerEntity = ModelEntity(mesh: markerMesh, materials: [markerMaterial])
        markerEntity.position = position
        
        return markerEntity
    }
    
    //    func clearMarkers() {
    //        // Remove each marker entity from the scene
    //        markerEntities.forEach { $0.removeFromParent() }
    //
    //        // Clear the list of markers
    //        markerEntities.removeAll()
    //    }
    
}



// Helper function to check if a point is inside a given bounding box
func isPointInsideBoundingBox(_ point: simd_float3, boundingBox: BoundingBox) -> Bool {
    return (point.x >= boundingBox.min.x && point.x <= boundingBox.max.x) &&
    (point.z >= boundingBox.min.z && point.z <= boundingBox.max.z)
}

// Helper to convert SCNVector3 to simd_float3
extension simd_float3 {
    init(_ scnVector: SCNVector3) {
        self.init(scnVector.x, scnVector.y, scnVector.z)
    }
}

// Helper function to find entities with a specific name in RealityKit
extension Entity {
    var visualBounds: BoundingBox {
        return self.visualBounds(relativeTo: self)
    }
    
    func findEntities(named name: String) -> Entity? {
        if self.name == name {
            return self
        }
        
        for child in children {
                if let found = child.findEntity(named: name) {
                    return found  // Return the first entity that matches the name
                }
            }
        
        return nil
    }
    
    func findAllEntities(excluding entityName: String = "Plane") -> [Entity] {
        var allEntities: [Entity] = []
        
        if self.name != entityName{
            allEntities.append(self)
        }
        
        for child in children {
            allEntities.append(contentsOf: child.findAllEntities(excluding: entityName))
        }
        
        return allEntities
    }
}

#Preview {
    ContentView()
}
