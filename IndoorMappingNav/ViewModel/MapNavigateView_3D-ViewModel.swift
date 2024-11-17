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
        
    }
}
