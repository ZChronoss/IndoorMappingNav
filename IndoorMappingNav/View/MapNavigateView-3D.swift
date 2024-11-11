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
    @EnvironmentObject var pathfinder: PathfindingService
    @State var isPresented: Bool = true
    
    var start: String
    var end: String
    
    var body: some View {
        VStack {
            RealityView { content in
                content.add(await mapLoader.getScene())
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
            .presentationDetents([.fraction(0.2), .fraction(0.75)])
            .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.2)))
            .interactiveDismissDisabled()
        }
        .onAppear() {
            pathfinder.startNavigation(start: start, end: end)
        }
    }
}

#Preview {
//    MapNavigateView_3D()
}
