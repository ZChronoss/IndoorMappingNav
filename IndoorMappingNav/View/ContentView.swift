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
                    scene?.setScale([scale, scale, scale], relativeTo: nil)
                    pathfinder.setupPath(loadedScene: scene!)
                    
                    pathfinder.startNavigation(start: "Huawei", end: "Lift")
                }
            }
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
            let path = pathfinder.interEntities.map { simd_float3($0.position.x, $0.position.y + 0.1, $0.position.z) }
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
        .padding()
    }
}

#Preview {
    ContentView()
}
