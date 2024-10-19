//
//  PathfindingService2D.swift
//  IndoorMappingNav
//
//  Created by Leonardo Marhan on 17/10/24.
//

import RealityKit
import GameplayKit

class PathfindingService2D {
    var currentPath: [simd_float3] = []
    var currentIndex = 0
    var objectEntity: Entity?
    var scene: Entity? = nil
    var cameraEntity: Entity?
    
    func setup2DNavigation(path: [simd_float3], scene: Entity) {
        self.currentPath = path
        self.scene = scene
        self.currentIndex = 0
        
        if let firstPosition = path.first {
            print(firstPosition)
            print(currentPath.count)
            objectEntity = createObjectEntity(at: firstPosition)
            scene.addChild(objectEntity!)
            
        }
        panCameraToFollow(objectEntity, xCamera: 0, zCamera: 0)
    }
    
    func createObjectEntity(at position: simd_float3) -> Entity {
        let object = MeshResource.generateBox(size: [0.1, 0.1, 0.1])
        let material = SimpleMaterial(color: .green, isMetallic: false)
        let objectEntity = ModelEntity(mesh: object, materials: [material])
        objectEntity.position = position
        return objectEntity
    }
    //MARK: +-20 MASIH UNTUK DEBUG, BELUM INPUT INTERSECTION
    func moveToNextNode() {
        guard currentIndex < currentPath.count - 1 else { return }
        
        currentIndex += 20
        moveObject(to: currentPath[currentIndex])
    }

    func moveToPreviousNode() {
        guard currentIndex > 0 else { return }
        
        currentIndex -= 20
        moveObject(to: currentPath[currentIndex])
    }
    
    func moveObject(to position: simd_float3) {
        let nextIndex = min(currentIndex + 20, currentPath.count - 1)
        let nextNode = currentPath[nextIndex]
        
        print(currentIndex)
        
        objectEntity?.position = position
        rotateCameraToFace(nextNode)
    }
    
    func rotateCameraToFace(_ nextNode: simd_float3) {
        guard let object = objectEntity else { return }

        let direction = normalize(nextNode - object.position)
        print("nextNode: ", nextNode)
        print("object: ", object.position)
        print("direction: ", direction)

        // Compute the angle based on the direction the object is moving
        let angle = atan2(direction.x, direction.z)

        // Instead of rotating the scene, rotate the camera to face the object’s direction
        cameraEntity?.orientation = simd_quatf(angle: angle, axis: [0, 1, 0])

        print("Rotating camera by angle: \(angle) radians to align with object direction")
        panCameraToFollow(objectEntity, xCamera: -sin(angle), zCamera: -cos(angle))
    }

    func panCameraToFollow(_ entity: Entity?, xCamera: Float, zCamera: Float) {
        guard let object = entity else { return }
        
        if let existingCamera = cameraEntity {
                existingCamera.removeFromParent()
            }

        let cameraPosition = simd_float3(object.position.x + xCamera, object.position.y + 5, object.position.z + zCamera)
        
        _ = CameraHelper.setupCamera(in: scene, cameraPosition: cameraPosition, lookAtPosition: object.position, fov: 50.0)
    }


    
}

