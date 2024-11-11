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
    
    var body: some View {
        VStack {
            RealityView { content in
                content.add(await mapLoader.getScene())
            }
            .realityViewCameraControls(.orbit)
        }
    }
}

#Preview {
    MapNavigateView_3D()
}
