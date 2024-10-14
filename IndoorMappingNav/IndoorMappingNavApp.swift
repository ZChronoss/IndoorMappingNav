//
//  IndoorMappingNavApp.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 01/10/24.
//

import SwiftUI
import CloudKit

@main
struct IndoorMappingNavApp: App {
    var body: some Scene {
        WindowGroup {
            CloudKitView()
        }
    }
}
