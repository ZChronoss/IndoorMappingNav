//
//  CategorySheet-ViewModel.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 29/10/24.
//

import Foundation

extension CategorySheet {
    
    class ViewModel: ObservableObject {
        private let cloudKitController = CloudKitController()
        
        @Published var storesByCategory: [Store] = []
        @Published var allSubCategories: [SubCategory] = []
        @Published var stores: [Store] = []
        @Published private(set) var isLoading = false
        
        @Published var selectedSubCategory: SubCategory?
        var filteredStores: [Store] {
            if let subCategory = selectedSubCategory {
                let filtered = storesByCategory.filter { store in
                    // Filter by the selected subcategory
                    let storeSubCategories = store.subcategory ?? []
                    return storeSubCategories.contains(subCategory.rawValue)
                }
                return filtered
            }
            return storesByCategory
        }
        
        func getStores(mallId: String) async {
            isLoading = true
            do {
                self.stores = try await cloudKitController.fetchStores(mallId: mallId)
            } catch {
                print("Error: Data fetching failed (\(error.localizedDescription))")
            }
            isLoading = false
        }
        
        func getStoreByCategory(_ category: String) async {
            do {
                let stores = try await cloudKitController.fetchStoreByCategory(category: category)
                DispatchQueue.main.async {
                    self.storesByCategory = stores
                    self.selectedSubCategory = nil
                    print("Fetched \(stores.count) stores for category: \(category)")
                }
            } catch {
                print("Failed to fetch stores by category: \(error.localizedDescription)")
            }
        }
        
        func getAllSubCategories() {
            if let category = storesByCategory.first?.category {
                allSubCategories = category.getSubCategories()
            } else {
                allSubCategories = []
            }
        }
    }
}
