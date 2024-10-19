//
//  CameraHelper.swift
//  IndoorMappingNav
//
//  Created by Leonardo Marhan on 18/10/24.
//

import RealityKit

class CameraHelper {
    
    static func setupCamera(in scene: Entity?, cameraPosition: simd_float3, lookAtPosition: simd_float3, fov: Float = 50.0) -> Entity? {
        guard let scene = scene else {
            print("Scene is nil. Cannot set up camera.")
            return nil
        }
        
        let cameraAnchor = AnchorEntity(world: cameraPosition)
        var perspectiveCameraComponent = PerspectiveCameraComponent()
        perspectiveCameraComponent.fieldOfViewInDegrees = fov
        
        let cameraEntity = Entity()
        cameraEntity.components[PerspectiveCameraComponent.self] = perspectiveCameraComponent
        cameraEntity.look(at: lookAtPosition, from: cameraPosition, relativeTo: nil)
        
        scene.addChild(cameraAnchor)
        cameraAnchor.addChild(cameraEntity)
        
        return cameraEntity
    }
}
