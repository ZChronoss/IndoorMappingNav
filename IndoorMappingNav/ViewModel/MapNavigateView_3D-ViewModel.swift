//
//  MapNavigateView_3D-ViewModel.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 11/11/24.
//

import Foundation
import SwiftUI
import RealityKit

extension MapNavigateView_3D {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var isPresented: Bool = true
        @Published var scene: Entity?
        @Published var start: String = ""
        @Published var end: String = ""
        var mapLoader = MapLoader()
        var pathfinder = PathfindingService()
        
        init(){
//            Task {
//                await scene = loadScene()
//            }
        }
        
        func loadScene() async -> Entity {
            guard let retScene = scene else {
                let tempScene = await mapLoader.getScene()
                pathfinder.setupPath(loadedScene: tempScene)
                
                pathfinder.startNavigation(start: start, end: end)
                return tempScene
            }
            return retScene
        }
    }
}
