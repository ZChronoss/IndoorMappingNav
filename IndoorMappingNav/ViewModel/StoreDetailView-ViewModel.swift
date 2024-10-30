//
//  StoreViewModel.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 07/10/24.
//

import Foundation

extension StoreDetailView {
    
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
        
        func getStoreDetail(_ name: String) async {
            isLoading = true
            
            do {
                self.store = try await cloudkitController.fetchStoreByName(name: name)
            } catch {
                print("Error: Data fetching failed (\(error.localizedDescription))")
            }
            
            isLoading = false
        }
    }
    
}
