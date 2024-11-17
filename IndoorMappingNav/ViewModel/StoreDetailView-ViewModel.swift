//
//  StoreViewModel.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 07/10/24.
//

import Foundation

extension StoreDetailView {
    
    @MainActor
    class ViewModel: ObservableObject {
        private let cloudkitController = CloudKitController()
        @Published var storeName: String = ""
        @Published var stores: [Store] = []
        
        @Published var store: Store = Store()
        @Published private(set) var isLoading = false
        
        func getStoreDetail() async {
            isLoading = true
            
            do {
                self.store = try await cloudkitController.fetchStoreByName(name: storeName)
            } catch {
                print("Error: Data fetching failed (\(error.localizedDescription))")
            }
            
            isLoading = false
        }
    }
    
}
