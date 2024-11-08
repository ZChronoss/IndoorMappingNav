//
//  HomeView-ViewModel.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 30/10/24.
//

import Foundation
import SwiftUI

//extension HomeViewComponents {
//    @MainActor
    class HomeViewModel: ObservableObject {
        private let cloudkitController = CloudKitController()
        /// SEARCH FUNC
        @Published var isSearching: Bool = false
        @Published var selectedDestination: Store?
        
        @Published var storeName: String = ""
        @Published var selectedStore: Store?
        
        @Published var isLoading = false
        
        @Published var isCategorySheetOpen = false
        @Published var categoryDetent: PresentationDetent = .fraction(0.17)
        
        func getStoreDetail() async {
//            isLoading = true
            
            do {
                self.selectedStore = try await cloudkitController.fetchStoreByName(name: storeName)
            } catch {
                print("Error: Data fetching failed (\(error.localizedDescription))")
            }
            
//            isLoading = false
        }
    }
//}
