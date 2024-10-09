//
//  ContentView.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 11/10/24.
//

import SwiftUI
import RealityKit
import GameplayKit
import MallMap

enum NodeType {
    case store
    case intersection
}

struct ContentView: View {
    @State private var entityPositions: [Entity: simd_float3] = [:] // Store only the original position
    @State private var entityState: [Entity: Bool] = [:]
    @State var isSheetOpen = false
    @State var selectedStore: String?
    @State var scale: Float = 1
    @State private var isMoving: Bool = false
    @State private var startScale: Float? = nil
    @State private var selectedCategory: String = "Food & Beverage"

    var body: some View {
        ZStack {
            // Main RealityView content
            RealityView { content in
                if let scene = try? await Entity(named: "Scene", in: mallMapBundle) {
                    content.add(scene)
                }
            }
            update: { content in
                if let glassCube = content.entities.first {
                    glassCube.setScale([scale, scale, scale], relativeTo: nil)
                }
            }
            .simultaneousGesture(
                MagnifyGesture()
                    .onChanged({ value in
                        if let startScale {
                            scale = max(0.5, min(2, Float(value.magnification) * startScale))
                        } else {
                            startScale = scale
                        }
                    })
                    .onEnded { _ in
                        startScale = scale
                    }
            )
            .gesture(
                SpatialTapGesture()
                    .targetedToAnyEntity()
                    .onEnded({ target in
                        guard !isMoving else { return } // Ignore tap if movement is ongoing
                        isMoving = true // Lock the tap gesture
                        let curTransform = target.entity.transform
                        let curTranslation = curTransform.translation
                        let moveUpDistance: Float = 0.5 // 1000cm = 10 meters
                        
                        // Check if the entity was clicked for the first time
                        if entityPositions[target.entity] == nil {
                            // Store the original position when clicked for the first time
                            entityPositions[target.entity] = curTranslation
                            entityState[target.entity] = false // Initially at original position
                        }
                        
                        if let originalPosition = entityPositions[target.entity], let
                            isMoved = entityState[target.entity] {
                            
                            var moveToLocation = curTransform
                            
                            if isMoved {
                                moveToLocation.translation = simd_float3(x: curTranslation.x,
                                                                         y: curTranslation.y - moveUpDistance,
                                                                         z: curTranslation.z)
                                entityState[target.entity] = false
                            } else {
                                moveToLocation.translation = simd_float3(x: curTranslation.x,
                                                                         y: curTranslation.y + moveUpDistance,
                                                                         z: curTranslation.z)
                                entityState[target.entity] = true
                            }
                            
                            // Move the entity up by 1000cm (10 meters)
                            target.entity.move(to: moveToLocation, relativeTo: target.entity.parent, duration: 0.5)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isMoving = false // Unlock the gesture after movement finishes
                                selectedStore = target.entity.name
                            }
                        }
                    })
            )
            .realityViewCameraControls(.orbit)

            // Overlay: Location title, search bar, and category buttons
            

            VStack {
                ZStack(alignment: .top) {
                    // White background rectangle
                    CustomCornerShape(radius: 20, corners: [.bottomLeft, .bottomRight])
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 10)
                        .frame(height: 95) // Adjust this value to control how far down the rectangle extends

                    VStack(spacing: 0) {
                        HStack {
                            Text("Summarecon Mall Serpong")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.black)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)

                        SearchBar(image: Image(systemName: "magnifyingglass"), iconColor: .secondary)
                            .padding(.horizontal, 20)
                    }
                }


                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryButton(categoryName: "Food & Beverage", categoryIcon: "fork.knife", categoryColor: .red, isSelected: selectedCategory == "Food & Beverage") {
                            selectedCategory = "Food & Beverage"
                        }
                        CategoryButton(categoryName: "Shopping", categoryIcon: "cart", categoryColor: .green, isSelected: selectedCategory == "Shopping") {
                            selectedCategory = "Shopping"
                        }
                        CategoryButton(categoryName: "Entertainment", categoryIcon: "gamecontroller", categoryColor: .purple, isSelected: selectedCategory == "Entertainment") {
                            selectedCategory = "Entertainment"
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 16)
                
                Spacer() // Push the RealityView to the bottom
            }
        }
        .onChange(of: selectedStore, { oldValue, newValue in
            isSheetOpen.toggle()
        })
        .sheet(isPresented: $isSheetOpen) {
            StoreDetailView()
                .presentationDetents([.fraction(0.5)])
                .presentationBackgroundInteraction(.enabled)
        }
        .padding(.top, 56)
        .ignoresSafeArea()
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

struct CustomCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


#Preview {
    ContentView()
}
