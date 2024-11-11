//
//  HomeView.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 11/10/24.
//

import SwiftUI
import RealityKit
import MallMap

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    
//    @StateObject private var vm: HomeViewModel
//
//    init() {
//        _vm = StateObject(wrappedValue: HomeViewModel(scene: nil))
//    }
    
    
    @StateObject var pathfinder = PathfindingService.shared
    @StateObject var pathfinder2D = PathfindingService2D.shared
    
    @State private var entityPositions: [Entity: simd_float3] = [:] // Store only the original position
    @State private var entityState: [Entity: Bool] = [:]
    
    @State var scale: Float = 0.2
//    @State private var isMoving: Bool = false
    @State private var originalMaterials: [Entity: [RealityKit.Material]] = [:] // Store original materials
    
    // ini apus aja kah?
//    @State private var selectedCategory: String = "Food & Beverage"
//    // Setelah gua tambahin ini, kenapa jadi beda
//    @State private var isCategorySheetOpen = false
//    @State var categoryDetent: PresentationDetent = .fraction(0.17)
    
    @State private var scene: Entity? = nil
    @State private var pathEntities: [Entity] = []
    @State var is2DMode = false
    
    @State private var lastSelectedCategory: String = "Food & Beverage" // Track the last selected category
    
    @StateObject var mapLoader = MapLoader()
    var body: some View {
        NavigationStack{
            ZStack {
                // Main RealityView content
                RealityView { content in
                    content.add(await mapLoader.getScene())

                        // Call categorizeEntityByStore function to categorize all entities in the scene
                        
        
                        // Print categoryStoreTarget contents
//                        vm.printCategoryStoreTarget()
                    }
                }
                .realityViewCameraControls(is2DMode ? .pan : .orbit)
                .gesture(
                    SpatialTapGesture()
                        .targetedToAnyEntity()
                        .onEnded({ target in
                            vm.handleEntitySelectionAndMovement(
                                target: target.entity,
                                entityPositions: &entityPositions,
                                entityState: &entityState
                            )
                        })
                )
                
                // Overlay: Location title, search bar, and category buttons
                if is2DMode == false {
                    HomeViewComponents(selectedCategory: $vm.selectedCategory)
                        .environmentObject(vm)
                }
                else {
                    NavigateView()
                }
                VStack {
                    Spacer()
                    
                    // Debugging
                    Button("Clicked") {
//                        vm.categorizeEntitiesInScene(scene!)
                        vm.printCategoryStoreTarget()
                    }
                    
                    
                    Button("2D Mode") {
                        // 3D to 2D path conversion (flatten Y-axis)
                        guard let scene = scene else { return }
                        scene.setScale([2,2,2], relativeTo: nil)
                        let path = pathfinder.interEntities.map { simd_float3($0.position.x, $0.position.y + 0.1, $0.position.z) }
                        guard let camera = pathfinder.cameraEntity else { return }
                        pathfinder2D.setup2DNavigation(path: path, scene: scene, camera: camera)
                        is2DMode = true
                    }
                    .padding(.bottom)
                }
            }
            .padding(.top, 56)
            .ignoresSafeArea()
            .environmentObject(pathfinder2D)
            .environmentObject(pathfinder)
            .environmentObject(mapLoader)
        }
        .onAppear(){
            Task {
                await vm.getStores()
                vm.categorizeEntitiesInScene(scene!)
            }
        }
    }
}

#Preview {
    HomeView()
}
