import SwiftUI
import RealityKit
import GameplayKit
import MallMap

struct ContentView: View {
    var pathfinder = PathfindingService()
    
    @State private var scene: Entity? = nil
    @State private var pathEntities: [Entity] = []
    
    @State var isSheetOpen = false
    @State var selectedStore: String?
    @State var scale: Float = 0.2
    
    @State private var cameraPosition = simd_float3(1, 1, 1)
    @State private var cameraLookAt = simd_float3(0, 0, 0)
    
    var body: some View {
        VStack {
            RealityView { content in
                if let loadedScene = try? await Entity(named: "Scene", in: mallMapBundle) {
                    //                    loadedScene.transform.scale = [scaleNum, scaleNum, scaleNum]
                    scene = loadedScene
                    content.add(scene!)
                    pathfinder.setupPath(loadedScene: scene!)
                    pathfinder.startNavigation(start: "Huawei", end: "Toilet")

                    let cameraAnchor = AnchorEntity(world: cameraPosition)
                    
                    // Create and add a camera to the anchor
                    let camera = PerspectiveCamera()
                    camera.look(at: cameraLookAt, from: cameraPosition, relativeTo: nil)
                    
                    cameraAnchor.addChild(camera)
                    content.add(cameraAnchor)
                }
            }
            update: { content in
                if let glassCube = content.entities.first {
                    glassCube.setScale([scale, scale, scale], relativeTo: nil)
                    //                    print(glassCube.name)
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
                .presentationBackgroundInteraction(.enabled)
        }
        
        Slider(value: $scale, in: 0...2)
            .padding()
    }
}

#Preview {
    ContentView()
}
