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
    
    var body: some View {
        VStack {
            RealityView { content in
                if let scene = try? await Entity(named: "Scene", in: mallMapBundle) {
                    let scaleNum: Float = 0.05
                    scene.transform.scale = [scaleNum, scaleNum, scaleNum]
                    content.add(scene)
                }
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
                        
                        //                        Task {
                        //                            // get store name
                        //                            selectedStore = target.entity.parent?.name
                        //                        }
                        //
                        //                        // toggle sheet
                        //                        isSheetOpen.toggle()
                        
                        DispatchQueue.main.async {
                            selectedStore = target.entity.parent?.name
                        }
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
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    ContentView()
}
