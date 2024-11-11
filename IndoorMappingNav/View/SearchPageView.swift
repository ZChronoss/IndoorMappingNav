//
//  SearchPageView.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 29/10/24.
//

import SwiftUI

struct SearchPageView: View {
    @StateObject private var vm = ViewModel()
    @Environment(\.dismiss) private var dismiss
    @State var destStore: Store = Store()
    
    @StateObject var mapLoader = MapLoader()
    @StateObject var pathfinder = PathfindingService()
    
    var openSheet: (Store) -> Void
    
    var body: some View {
        VStack() {
            if !vm.hasSelectedDestination {
                SearchBarWithCancel(searchText: $vm.searchText)
                    .padding(.horizontal)
            }else{
                SearchBarDouble(searchText: $vm.startStoreName, searchText2: $vm.destStoreName, startStoreFloor: vm.startStoreFloor, destStoreFloor: vm.destStoreFloor) { type in
                    switch type {
                    case .start:
                        vm.trueIfStartStoreIsSelected = true
                    case .destination:
                        vm.trueIfStartStoreIsSelected = false
                    }
                }
                .padding(.horizontal)
            }
            
            
            if vm.hasSelectedStart {
                MapNavigateView_3D(start: vm.startStoreName, end: vm.destStoreName)
                    .environmentObject(mapLoader)
                    .environmentObject(pathfinder)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(vm.searchText.isEmpty ? vm.searchHistory : vm.filteredStores) {store in
                            SearchResult(store: store)
                                .onTapGesture {
                                    if !vm.hasSelectedDestination {
                                        vm.destStoreName = ""
                                        destStore = Store()
                                        vm.hasSelectedDestination = false
                                        openSheet(store)
                                        dismiss()
                                    }
                                    vm.setStoreFromDefault(store.name ?? "")
                                    print(vm.searchHistory)
                                    vm.hasSelectedDestination = true
                                    
                                    if vm.trueIfStartStoreIsSelected {
                                        vm.startStoreName = store.name ?? ""
                                        vm.startStoreFloor = SearchResult.getFloorAbbreviation(floor: store.floor ?? "")
                                        vm.hasSelectedStart = true
                                    }else{
                                        vm.destStoreName = store.name ?? ""
                                        vm.destStoreFloor = SearchResult.getFloorAbbreviation(floor: store.floor ?? "")
                                    }
                                }
                        }
                    }
                    .padding(.top)
                }
                .redacted(reason: vm.isLoading ? .placeholder : [])
            }
        }
        .background(.white)
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            vm.destStoreName = self.destStore.name ?? ""
            vm.destStoreFloor = self.destStore.floor.map(SearchResult.getFloorAbbreviation) ?? ""
            
            if !vm.destStoreName.isEmpty {
                vm.hasSelectedDestination = true
            }
        }
    }
}

#Preview {
    SearchPageView{ _ in }
}
