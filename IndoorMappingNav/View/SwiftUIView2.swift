//import SwiftUI
//import RealityKit
//import MallMap
//
//struct ContentView: View {
//    @State private var entityPositions: [Entity: simd_float3] = [:] // Store only the original position
//    @State private var entityState: [Entity: Bool] = [:]
//    @State var isSheetOpen = false
//    @State var selectedStore: String?
//    @State var scale: Float = 1
//    @State private var isMoving: Bool = false
//    
//    var body: some View {
//        VStack {
//            RealityView { content in
//                if let scene = try? await Entity(named: "Scene", in: mallMapBundle) {
//                    content.add(scene)
//                }
//
//            }
//            update: { content in
//                if let glassCube = content.entities.first {
//                    glassCube.setScale([scale, scale, scale], relativeTo: nil)
//                }
//            }
//            .gesture(
//                SpatialTapGesture()
//                    .targetedToAnyEntity()
//                    .onEnded({ target in
//                        guard !isMoving else { return } // Ignore tap if movement is ongoing
//                        isMoving = true // Lock the tap gesture
//                        let curTransform = target.entity.transform
//                        let curTranslation = curTransform.translation
//                        
//                        
//                        
//                        // Move the entity up by 1000cm (10 meters)
//                        let moveUpDistance: Float = 1 // 1000cm = 10 meters
//                        var moveToLocation = curTransform
//                        moveToLocation.translation = simd_float3(x: curTranslation.x,
//                                                                 y: curTranslation.y + moveUpDistance,
//                                                                 z: curTranslation.z)
//                        
//                        
//                        target.entity.move(to: moveToLocation, relativeTo: target.entity.parent, duration: 0.5)
//                        
//                        print("Moving \(target.entity.name) up by 10 meters")
//                        
//                        DispatchQueue.main.async {
//                            selectedStore = target.entity.parent?.name
//                        }
//                    })
//            )
//            .realityViewCameraControls(.orbit)
//        }
//        .onChange(of: selectedStore, { oldValue, newValue in
//            isSheetOpen.toggle()
//        })
//        .sheet(isPresented: $isSheetOpen) {
//            StoreDetailView(storeName: selectedStore ?? "Error: No Store Selected")
//                .presentationDetents([.fraction(0.5)])
//                .presentationBackgroundInteraction(.enabled)
//        }
//        
//        Slider(value: $scale, in: 0...2)
//            .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}
