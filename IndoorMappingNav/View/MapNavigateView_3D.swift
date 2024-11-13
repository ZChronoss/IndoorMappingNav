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
    
    @Binding var isPresented: Bool
    
    @State var start: String
    @State var end: String
    
//    @State var scene: Entity?
    var body: some View {
        VStack {
            RealityView { content in
                vm.scene = await mapLoader.getScene()
                pathfinder.setupPath(loadedScene: vm.scene ?? Entity())
                pathfinder.startNavigation(start: vm.start, end: vm.end)
                content.add(vm.scene ?? Entity())
            }
            .realityViewCameraControls(.orbit)
        }
        .sheet(isPresented: $isPresented) {
            NavigationSheetDetail(
                instructions: pathfinder.instructions,
                pathCounts: pathfinder.pathCounts
            )
            .padding(.top)
            .presentationDragIndicator(.visible)
            .presentationContentInteraction(.scrolls)
            .presentationDetents([.fraction(0.25), .fraction(0.75)])
            .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.2)))
            .interactiveDismissDisabled()
        }
//        .task {
//            await scene = mapLoader.getScene()
//            pathfinder.setupPath(loadedScene: scene ?? Entity())
//            
//            pathfinder.startNavigation(start: start, end: end)
//        }
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
