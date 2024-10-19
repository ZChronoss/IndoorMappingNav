import SwiftUI
import RealityKit
import GameplayKit
import MallMap

struct ContentView: View {
    var pathfinder = PathfindingService()
    var pathfinder2D = PathfindingService2D()
    
    @State private var scene: Entity? = nil
    @State private var pathEntities: [Entity] = []
    
    @State var isSheetOpen = false
    @State var selectedStore: String?
    @State var scale: Float = 0.2
    
    var body: some View {
        VStack {
            RealityView { content in
                if let loadedScene = try? await Entity(named: "Scene", in: mallMapBundle) {
                    //                    loadedScene.transform.scale = [scaleNum, scaleNum, scaleNum]
                    scene = loadedScene
                    content.add(scene!)
                    pathfinder.setupPath(loadedScene: scene!)
                    
                    pathfinder.startNavigation(start: "G_factory", end: "Huawei")
                }
            }
            update: { content in
                print(scale)
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
        Button("2D Mode") {
            // 3D to 2D path conversion (flatten Y-axis)
            guard let scene = scene else { return }
            scene.setScale([2,2,2], relativeTo: nil)
            let path = pathfinder.pathEntities.map { simd_float3($0.position.x, $0.position.y + 0.1, $0.position.z) }
            pathfinder2D.setup2DNavigation(path: path, scene: scene)
        }
        // Navigation buttons
                    HStack {
                        Button("Previous") {
                            pathfinder2D.moveToPreviousNode()
                        }
                        Button("Next") {
                            pathfinder2D.moveToNextNode()
                        }
                    }
        Slider(value: $scale, in: 0...3)
            .padding()
    }
}

#Preview {
    ContentView()
}
