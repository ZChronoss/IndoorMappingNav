//
//  PathfindingService2D.swift
//  IndoorMappingNav
//
//  Created by Leonardo Marhan on 17/10/24.
//

import RealityKit
import GameplayKit

class PathfindingService2D: ObservableObject {
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
    
    func moveToNextNode() {
        guard currentIndex < currentPath.count - 1 else { return }
        
        currentIndex += 1
        moveObject(to: currentPath[currentIndex])
    }
    
    func moveToPreviousNode() {
        guard currentIndex > 0 else { return }
        
        currentIndex -= 1
        moveObject(to: currentPath[currentIndex])
    }
    
    func moveObject(to position: simd_float3) {
        guard currentIndex < currentPath.count else { return }
        
        let nextIndex = currentIndex + 1
        
        guard nextIndex < currentPath.count else {
            objectEntity?.position = position
            panCameraToFollow(objectEntity, xCamera: 0, zCamera: 0)
            return
        }
        
        let nextNode = currentPath[nextIndex]
        objectEntity?.position = position
        
        if nextNode != position {
            rotateCameraToFace(nextNode)
        } else {
            print("Next node is the same as the current node, no rotation needed.")
        }
    }
    
    func rotateCameraToFace(_ nextNode: simd_float3) {
        guard let object = objectEntity else { return }
        
        let direction = normalize(nextNode - object.position)
        
        // Compute the angle based on the direction the object is moving
        let angle = atan2(direction.x, direction.z)
        
        // Instead of rotating the scene, rotate the camera to face the object’s direction
        cameraEntity?.orientation = simd_quatf(angle: angle, axis: [0, 1, 0])
        
        panCameraToFollow(objectEntity, xCamera: -sin(angle), zCamera: -cos(angle))
    }
  
    func panCameraToFollow(_ entity: Entity?, xCamera: Float, zCamera: Float) {
        guard let object = entity, let cameraEntity = cameraEntity else { return }
        
        let cameraPosition = simd_float3(object.position.x + xCamera, object.position.y + 3, object.position.z + zCamera)

        cameraEntity.position = cameraPosition
        cameraEntity.look(at: object.position, from: cameraPosition, relativeTo: scene)

        print("TEST", cameraPosition, object.position)
        // Attach the camera directly to the scene
        scene?.addChild(cameraEntity)
    }

}

