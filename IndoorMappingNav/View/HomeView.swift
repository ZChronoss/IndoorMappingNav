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
    
    @State private var scene: Entity? = nil
    @State private var refreshRealityView: Bool = false
    
    @StateObject var mapLoader = MapLoader()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if refreshRealityView {
                    RealityView { content in
                        print("loading scene", mapLoader.mapName)
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
                } else {
                    // Main RealityView content
                    RealityView { content in
                        print("loading scene", mapLoader.mapName)
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
                }
                
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
                await vm.getStores(mallId: vm.mallId)
                await vm.categorizeEntitiesInScene(mapLoader.getScene())
            }
            
        }
        .onChange(of: vm.mallId) { _, _ in
            mapLoader.mapName = vm.mallId == "-1" ? "AppleDev" : "Test2"
            refreshRealityView.toggle()
            print(mapLoader.mapName)
        }
    }
}

#Preview {
    HomeView()
}
