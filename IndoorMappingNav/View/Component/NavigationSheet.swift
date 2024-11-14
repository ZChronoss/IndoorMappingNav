//
//  NavigationSheet.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 18/10/24.
//

import SwiftUI
import RealityKit

struct NavigationSheet: View {
    var distance: Int
    var currentScene: Entity?
    @StateObject var pathfinder = PathfindingService.shared
    @StateObject var pathfinder2D = PathfindingService2D.shared
    
    @EnvironmentObject var vmNav: NavigationViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            Text(String(distance))
                .font(.title2)
                .foregroundColor(Color.blue)
                .fontWeight(.bold)
            
            Text("min walk")
                .font(.title2)
                .foregroundColor(Color.blue)
            
            Spacer()
            
            Button(action: {
                guard let scene = currentScene else { return }
                scene.setScale([2,2,2], relativeTo: nil)
                let path = pathfinder.interEntities.map { simd_float3($0.position.x, $0.position.y + 0.1, $0.position.z) }
                guard let camera = pathfinder.cameraEntity else { return }
                pathfinder2D.setup2DNavigation(path: path, scene: scene, camera: camera)
                vmNav.is2DMode = true
                }) {
                    HStack {
                        Image(systemName: "location.north.fill")

                        Text("Navigate")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                }
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.blue)
                )
                .foregroundColor(.white)

        }
        .frame(height: 100)
        .environmentObject(pathfinder)
        .environmentObject(pathfinder2D)
    }
}

//#Preview {
//    NavigationSheet(distance: 7)
//}
