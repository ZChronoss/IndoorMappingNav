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
    @State var isSheetOpen = false
    @State var selectedStore: String?
    @State var scale: Float = 1
    
    var body: some View {
        VStack {
            RealityView { content in
                if let scene = try? await Entity(named: "Scene", in: mallMapBundle) {
                    let scaleNum: Float = 0.05
                    scene.transform.scale = [scaleNum, scaleNum, scaleNum]
                    content.add(scene)
                }
            }
            update: { content in
                if let glassCube = content.entities.first {
                    glassCube.setScale([scale, scale, scale], relativeTo: nil)
                }
            }
            .gesture(
                SpatialTapGesture()
                    .targetedToAnyEntity()
                    .onEnded({ result in
//                        let curTransform = target.entity.transform
//                        let curTranslation = curTransform.translation
//                        
//                        /// Koentji nya disini: relative to nil bakal refer scale entity ke world
//                        /// Jadi kita bisa samain gerakannya based on world's scale
//                        let entityScale = target.entity.scale(relativeTo: nil)
//                        let moveDistance: Float = 0.05
//                        let scaledMovement: Float = moveDistance / entityScale.y
//                        print(target.entity.scale(relativeTo: nil).y)
//                        
//                        var moveToLocation = curTransform
//                        moveToLocation.translation = simd_float3(x: curTranslation.x,
//                                                                 y: curTranslation.y + scaledMovement,
//                                                                 z: curTranslation.z)
//                        
//                        target.entity.move(to: moveToLocation, relativeTo: nil, duration: 0.5)
//                        
//                        //                        Task {
//                        //                            // get store name
//                        //                            selectedStore = target.entity.parent?.name
//                        //                        }
//                        //
//                        //                        // toggle sheet
//                        //                        isSheetOpen.toggle()
//                        
//                        DispatchQueue.main.async {
//                            selectedStore = target.entity.name
//                        }
//                        
//                        print(isSheetOpen)
                        // Move the entity upward by increasing its y position
                        let tappedEntity = result.entity   
                                                
                        // Get the current position of the entity
                        let currentPosition = tappedEntity.position(relativeTo: nil)
                        let upwardOffset: Float = 0.1 // Amount to move upward
                        
                        // Create a new position by moving the entity upwards
                        let newPosition = SIMD3<Float>(currentPosition.x, currentPosition.y + upwardOffset, currentPosition.z)
                        
                        // Move the entity to the new position
                        tappedEntity.move(to: Transform(scale: [scale, scale, scale], rotation: .init(), translation: newPosition), relativeTo: nil, duration: 1.0)


//                        guard let tappedEntity = result.entity  {
//                            // Get the hit position on the entity
//                            let tapPosition = result.entity.position(relativeTo: tappedEntity)
//                            
//                            // Update the target position based on the tap position
//                            targetPosition = SIMD3<Float>(tapPosition.x, tapPosition.y, tapPosition.z)
//                        }
                    })
            )
            .realityViewCameraControls(.orbit)
        }
        .onChange(of: selectedStore, { oldValue, newValue in
            isSheetOpen.toggle()
        })
        .sheet(isPresented: $isSheetOpen) {
            StoreDetailView(storeName: selectedStore ?? "Error: No Store Selected")
                .presentationDetents([.fraction(0.5)])
                .presentationBackgroundInteraction(.enabled)
        }
        
        Slider(value: $scale, in: 0...2)
            .padding()
    }
}

#Preview {
    ContentView()
}
