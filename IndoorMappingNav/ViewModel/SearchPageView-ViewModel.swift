//
//  SearchPageView-ViewModel.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 29/10/24.
//

import Foundation

extension SearchPageView {
    @MainActor
    class ViewModel: ObservableObject {
        private let cloudkitController = CloudKitController()
        let defaults = UserDefaults.standard
        
        @Published var hasSelectedDestination: Bool = false
        @Published var hasSelectedStart: Bool = false
        
        // To store all Stores
        @Published var stores: [Store] = []
        // To store filtered Stores
        @Published var filteredStores: [Store] = []
        // To store search history
        @Published var searchHistory: [Store] = []
        
        @Published private(set) var isLoading = false
        @Published var searchText: String  = "" {
            didSet {
                filteredStores = filterStore(stores: stores, query: searchText)
            }
        }
        
        @Published var destStoreName: String = "" {
            didSet {
                searchText = destStoreName
            }
        }
        
        @Published var startStoreName: String = "" {
            didSet {
                searchText = startStoreName
            }
        }
        
        var destStoreFloor: String = ""
        var startStoreFloor: String = ""
        
        var trueIfStartStoreIsSelected: Bool = false
        var trueIfDestStoreIsSelected: Bool = false
        
        init() {
            Task {
                await getStores(mallId: "-1")
                
//                searchHistory = getStoreFromDefault() ?? []
            }
        }
        
        private func filterStore(stores: [Store], query: String) -> [Store]{
            guard !query.isEmpty else {
                return stores
            }
            
            let lowercasedText = query.lowercased()
            
            return stores.filter { (store) -> Bool in
                return (store.name?.lowercased().starts(with: lowercasedText) ?? false)
            }
            
        }
        
        func getStores(mallId: String) async {
            self.isLoading = true
            
            do {
                guard let gotStores = try? await cloudkitController.fetchStores(mallId: mallId) else {
                    self.stores = []
                    return
                }
                await MainActor.run {
                    self.stores = gotStores
                }
            }
            
            self.isLoading = false
        }
        
        func getStoreFromDefault() -> [Store]? {
            // Get names from User Default
            guard let names = defaults.stringArray(forKey: "storeName") else { return [] }
            
            var defaultStores: [Store] = []
            
            // Loop through the names and search for the store by name
            for name in names {
                if let store = stores.first(where: { store in
                    store.name == name
                }){
                    defaultStores.append(store)
                }
            }
            
            return defaultStores.reversed()
        }
        
        func setStoreFromDefault(_ name: String) {
            var nameArr = defaults.stringArray(forKey: "storeName")
            
            if nameArr == nil {
                nameArr = []
            }
            
            if ((nameArr?.contains(name)) != nil) {
                nameArr?.removeAll(where: { removeName in
                    removeName == name
                })
            }
            
            nameArr?.append(name)
            
            if nameArr?.count ?? 0 > 5 {
                nameArr?.removeFirst()
            }
            
            defaults.removeObject(forKey: "storeName")
            defaults.set(nameArr, forKey: "storeName")
            searchHistory = getStoreFromDefault() ?? []
        }
    }
}
