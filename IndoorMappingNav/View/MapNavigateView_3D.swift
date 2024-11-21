//
//  MapNavigateView-3D.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 08/11/24.
//

import SwiftUI
import RealityKit
import MallMap

struct MapNavigateView_3D: View {
    @EnvironmentObject var mapLoader: MapLoader
    @StateObject var pathfinder = PathfindingService.shared
    @StateObject var vm = ViewModel()
    @EnvironmentObject var vmNav: NavigationViewModel
    
    @Binding var isPresented: Bool
    
    @State var start: String
    @State var end: String
    
//    @State var scene: Entity?
    var body: some View {
        VStack {
            RealityView { content in
                vm.scene = await mapLoader.getScene()
                print(vm.scene)
                pathfinder.setupPath(loadedScene: vm.scene ?? Entity())
                pathfinder.startNavigation(start: vm.start, end: vm.end)
                content.add(vm.scene ?? Entity())
            }
            .realityViewCameraControls(vmNav.is2DMode ? .pan : .orbit)
        }
        .sheet(isPresented: Binding(
            get: { !vmNav.is2DMode },
            set: { newValue in vm.isPresented = newValue }
        )) {
            NavigationSheetDetail(
                instructions: pathfinder.instructions,
                pathCounts: pathfinder.pathCounts,
                currentScene: vm.scene
            )
            .presentationDetents([.height(200), .fraction(0.75)])
            .presentationBackgroundInteraction(.enabled(upThrough: .height(200)))
            .interactiveDismissDisabled()
            .presentationDragIndicator(.visible)
            .presentationContentInteraction(.scrolls)
        }
        .onAppear() {
            let newStart = start.replacingOccurrences(of: " ", with: "_")
            vm.start = newStart
            
            let newEnd = end.replacingOccurrences(of: " ", with: "_")
            vm.end = newEnd
                
        }
    }
}

#Preview {
//    MapNavigateView_3D()
}
