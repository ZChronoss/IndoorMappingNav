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
    @StateObject var pathfinder = PathfindingService.shared
    @StateObject var pathfinder2D = PathfindingService2D.shared
    
    @State private var entityPositions: [Entity: simd_float3] = [:] // Store only the original position
    @State private var entityState: [Entity: Bool] = [:]
    
    @State var scale: Float = 0.2
    @State private var originalMaterials: [Entity: [RealityKit.Material]] = [:] // Store original materials
    
    @State private var scene: Entity? = nil
    @State private var pathEntities: [Entity] = []
    
    @State private var lastSelectedCategory: String = "Food & Beverage" // Track the last selected category
    
    @StateObject var mapLoader = MapLoader()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main RealityView content
                RealityView { content in
                    scene = await mapLoader.getScene()
                    content.add(scene ?? Entity())
                    vm.categorizeEntitiesInScene(scene!)
                }
                .realityViewCameraControls(.orbit)
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
                    HomeViewComponents(selectedCategory: $vm.selectedCategory)
                        .environmentObject(vm)
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
                await vm.categorizeEntitiesInScene(mapLoader.getScene())
            }
            
        }
    }
}

#Preview {
    HomeView()
}
