//
//  IndoorMappingNavApp.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 01/10/24.
//

import SwiftUI

@main
struct IndoorMappingNavApp: App {
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
        }
    }
}
