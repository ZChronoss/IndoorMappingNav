//
//  ContentView.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 01/10/24.
//

import SwiftUI
import RealityKit
import MallMap

struct ContentView: View {
    var body: some View {
        VStack {
            Text("hai")
            RealityView { content in
                if let scene = try? await Entity(named: "Scene", in: mallMapBundle) {
                    let scaleNum: Float = 0.05
                    scene.transform.scale = [scaleNum, scaleNum, scaleNum]
                    content.add(scene)
                }
            } update: { content in
                
            }
            .gesture(
                SpatialTapGesture()
                    .targetedToAnyEntity()
                    .onEnded({ target in
                        let curTransform = target.entity.transform
                        let curTranslation = curTransform.translation
                        
                        /// Koentji nya disini: relative to nil bakal refer scale entity ke world
                        /// Jadi kita bisa samain gerakannya based on world's scale
                        let entityScale = target.entity.scale(relativeTo: nil)
                        let moveDistance: Float = 0.5
                        let scaledMovement: Float = moveDistance / entityScale.z
                        print(target.entity.scale(relativeTo: nil).z)
                        
                        var moveToLocation = curTransform
                        moveToLocation.translation = simd_float3(x: curTranslation.x,
                                                                 y: curTranslation.y,
                                                                 z: curTranslation.z + scaledMovement)
                        
                        target.entity.move(to: moveToLocation, relativeTo: target.entity, duration: 0.5)
                    })
            )
            .realityViewCameraControls(.orbit)
        }
    }
}

#Preview {
    ContentView()
}
