//
//  MapLoader.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 11/11/24.
//

import SwiftUI
import RealityKit
import MallMap

// This is a singleton class to load 3d map

class MapLoader: ObservableObject {
    static let shared = MapLoader()
    var scene: Entity? = nil
    var scale: Float = 0.2
    @Published var mapName: String = "AppleDev" //MARK: Buat start navigation masih belum ke ubah
    
    init() {
                Task{
                    await loadScene()
                }
    }
    
    private func loadScene() async {
        if let loadedScene = try? await Entity(named: mapName, in: mallMapBundle) {
            await loadedScene.setScale([scale, scale, scale], relativeTo: nil)
            scene = loadedScene
        } else {
            print("Failed to load the scene.")
        }
    }
    
    
    func getScene() async -> Entity {
        await loadScene()
//        if scene == nil {
//            await loadScene()
//        }
//        
        guard let scene = scene else {
            print("Scene is still not loaded.")
            return await Entity()
        }
        
        return scene
    }
}
