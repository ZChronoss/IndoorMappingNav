//
//  SearchPageView-ViewModel.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 29/10/24.
//

import Foundation

extension SearchPageView {
    class ViewModel: ObservableObject {
        private let cloudkitController = CloudKitController()
        @Published var stores: [Store] = []
        
        @Published var store: Store = Store()
        @Published private(set) var isLoading = false
        
        
        func getStores() async {
            isLoading = true
            
            do {
                self.stores = try await cloudkitController.fetchStores()
            } catch {
                print("Error: Data fetching failed (\(error.localizedDescription))")
            }
            
            isLoading = false
        }
    }
}
