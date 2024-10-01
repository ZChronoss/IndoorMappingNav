//
//  MallScene.swift
//  CobaSceneKit
//
//  Created by Renaldi Antonio on 30/09/24.
//

import Foundation
import SceneKit
import SwiftUI

struct MallScene: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = SCNView()
        view.scene = SCNScene(named: "SMS.scn")
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.defaultCameraController.maximumVerticalAngle = 45
        view.defaultCameraController.minimumVerticalAngle = 25
        view.defaultCameraController.inertiaFriction = 1
        view.defaultCameraController.interactionMode = .orbitTurntable
        
        if (view.hitTest(UITouch().location(in: view), options: nil).first?.node) != nil {
            print("touch")
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }

}
