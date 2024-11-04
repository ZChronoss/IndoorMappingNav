//
//  PathfindingService2D.swift
//  IndoorMappingNav
//
//  Created by Leonardo Marhan on 17/10/24.
//

import RealityKit
import GameplayKit

class PathfindingService2D: ObservableObject {
    static let shared = PathfindingService2D()
    var currentPath: [simd_float3] = []
    var currentIndex = 0
    var objectEntity: Entity?
    var scene: Entity? = nil
    var cameraEntity: Entity?
    
    func setup2DNavigation(path: [simd_float3], scene: Entity, camera: Entity) {
        self.currentPath = path
        self.scene = scene
        self.currentIndex = 0
        
        cameraEntity = camera
        
        if let firstPosition = path.first {
            print(firstPosition)
            print(currentPath.count)
            guard let newObjectEntity = createObjectEntity(at: firstPosition) else {
                return
            }
            
            objectEntity = newObjectEntity
            scene.addChild(newObjectEntity)

            rotateCameraToFace(currentPath[currentIndex+1])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.000000001) {
                self.rotateCameraToFace(self.currentPath[self.currentIndex+1])
            }
        }
    }
    
    func createObjectEntity(at position: simd_float3) -> Entity? {
        let object = MeshResource.generateBox(size: [0.1, 0.1, 0.1])
        let material = SimpleMaterial(color: .green, isMetallic: false)
        let objectEntity = ModelEntity(mesh: object, materials: [material])
        objectEntity.position = position
        return objectEntity
    }
    
    func moveObject(to currentIndex: Int) {
        guard currentIndex < currentPath.count else { return }

        let position = currentPath[currentIndex]
        objectEntity?.position = position
        
        let nextNode: simd_float3
        
        if currentIndex == currentPath.count - 1, currentIndex > 0 {
            let prevNode = currentPath[currentIndex - 1]
            let lastDirection = normalize(position - prevNode)
            nextNode = position + lastDirection // Extend in the same direction
        } else {
            nextNode = currentPath[currentIndex + 1]
        }
        
        rotateCameraToFace(nextNode)
    }
    
    func rotateCameraToFace(_ nextNode: simd_float3) {
        guard let object = objectEntity else { return }
        
        let direction = normalize(nextNode - object.position)
        
        // Compute the angle based on the direction the object is moving
        let angle = atan2(direction.x, direction.z)
        
        // Rotate the camera to face the object’s direction
        cameraEntity?.orientation = simd_quatf(angle: angle, axis: [0, 1, 0])
        
        panCameraToFollow(objectEntity, xCamera: -sin(angle), zCamera: -cos(angle))
    }
  
    func panCameraToFollow(_ entity: Entity?, xCamera: Float, zCamera: Float) {
        guard let object = entity, let cameraEntity = cameraEntity else { return }
        
        let cameraPosition = simd_float3(object.position.x + xCamera, object.position.y + 3, object.position.z + zCamera)

        cameraEntity.position = cameraPosition
        cameraEntity.look(at: object.position, from: cameraPosition, relativeTo: scene)

        // Attach the camera directly to the scene
        scene?.addChild(cameraEntity)
    }

}

