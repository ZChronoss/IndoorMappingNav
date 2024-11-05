//
//  SearchPageView-ViewModel.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 29/10/24.
//

import Foundation
import Combine


extension Publisher {
    func asyncMap<T>(
        _ transform: @escaping (Output) async throws -> T
    ) -> Publishers.FlatMap<Future<T, Error>,
                            Publishers.SetFailureType<Self, Error>> {
                                flatMap { value in
                                    Future { promise in
                                        Task {
                                            do {
                                                let output = try await transform(value)
                                                promise(.success(output))
                                            } catch {
                                                promise(.failure(error))
                                            }
                                        }
                                    }
                                }
                            }
}

extension SearchPageView {
    @MainActor
    class ViewModel: ObservableObject {
        private let cloudkitController = CloudKitController()
        
        @Published var hasSelectedDestination: Bool = false
        
        // To store all Stores
        @Published var stores: [Store] = []
        // To store filtered Stores
        @Published var filteredStores: [Store] = []
        
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
        
        private var cancellables = Set<AnyCancellable>()
        
        var trueIfStartStoreIsSelected: Bool = false
        
        init() {
            Task {
                await getStores()
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
        
        func getStores() async {
            self.isLoading = true
            
            do {
                guard let stores = try? await cloudkitController.fetchStores() else {
                    self.stores = []
                    return
                }
                await MainActor.run {
                    self.stores = stores
                }
            }
            
            self.isLoading = false
        }
        
        func getSearchedStores() {
            $searchText
                .map { text in
                    //                    DispatchQueue.main.async {
                    //                        self.isLoading = true
                    //                    }
                    
                    guard !text.isEmpty else {
                        return self.stores
                    }
                    
                    let lowercasedText = text.lowercased()
                    
                    //                    DispatchQueue.main.async {
                    //                        self.isLoading = false
                    //                    }ˆ
                    
                    return self.stores.filter { (store) -> Bool in
                        return (store.name?.lowercased().contains(lowercasedText))!
                    }
                }
                .sink{ [weak self] (returnVal) in
                    self?.stores = returnVal
                }
                .store(in: &cancellables)
            
            //            $searchText
            //                .asyncMap({ text in
            //                    DispatchQueue.main.async {
            //                        self.isLoading = true
            //                    }
            //
            //                    let retVal = text.isEmpty ? self.stores : self.stores.filter {
            //                        $0.name?.ranges(of: text) != nil
            //                    }
            //
            //                    DispatchQueue.main.async {
            //                        self.isLoading = false
            //                    }
            //
            //                    return retVal
            //                }).sink(receiveCompletion: { completion in
            //                    print(completion)
            //                }, receiveValue: { value in
            //                    DispatchQueue.main.async {
            //                        self.stores = value
            //                    }
            //                })
            //                .store(in: &cancellables)
            
            //            do {
            //                self.stores = try await cloudkitController.fetchStoreBeginsWith(keyword)
            //            } catch {
            //                print("Error: Data fetching failed (\(error.localizedDescription))")
            //            }
            
        }
    }
}
