//
//  SearchPageView.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 29/10/24.
//

import SwiftUI
import RealityKit

struct SearchPageView: View {
    @StateObject private var vm = ViewModel()
    @Environment(\.dismiss) private var dismiss
    @State var destStore: Store = Store()
    
    @StateObject var mapLoader = MapLoader()
    @StateObject var pathfinder = PathfindingService.shared
    @StateObject var pathfinder2D = PathfindingService2D.shared
    
    @StateObject var vmNav = NavigationViewModel()
    
    var openSheet: (Store) -> Void
    
    @State var isInstructionSheetPresented: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            if !vmNav.is2DMode {
                if !vm.hasSelectedDestination {
                    SearchBarWithCancel(searchText: $vm.searchText)
                        .padding(.horizontal)
                }else{
                    SearchBarDouble(searchText: $vm.startStoreName, searchText2: $vm.destStoreName, startStoreFloor: vm.startStoreFloor, destStoreFloor: vm.destStoreFloor) { type in
                        switch type {
                        case .start:
                            vm.trueIfStartStoreIsSelected = true
                            vm.trueIfDestStoreIsSelected = false
                        case .destination:
                            vm.trueIfDestStoreIsSelected = true
                            vm.trueIfStartStoreIsSelected = false
                        }
                    } instructionSheetDown: {
                        isInstructionSheetPresented = false
                    }
                    .padding(.horizontal)
                }
            }
            
            ZStack {
                if vm.hasSelectedStart && (!vm.trueIfStartStoreIsSelected && !vm.trueIfDestStoreIsSelected) {
                    MapNavigateView_3D(isPresented: $isInstructionSheetPresented, start: vm.startStoreName, end: vm.destStoreName)
                        .environmentObject(mapLoader)
                        .environmentObject(pathfinder)
                        .environmentObject(vmNav)
                } else {
                    VStack(alignment: .leading) {
                        let searchHistoryIsEmpty = vm.searchHistory.isEmpty
                        let searchTextIsEmpty = vm.searchText.isEmpty
                        
                        if searchTextIsEmpty {
                            VStack(alignment: .leading) {
                                Text("Recent")
                                    .font(.system(.caption, weight: .medium))
                                    .foregroundStyle(Color("sColor"))
                            }
                            .padding(.top, 10)
                            .padding(.horizontal)
                            
                        }
                        if searchHistoryIsEmpty && searchTextIsEmpty {
                            Spacer()
                            HStack {
                                Spacer()
                                VStack(alignment: .center){
                                    Image("LogoWhite")
                                        .resizable()
                                        .renderingMode(.template)
                                        .scaledToFit()
                                        .frame(width: 124)
                                        .opacity(0.5)
                                        .foregroundStyle(.logoWhiteCol)
                                    
                                    Text("No recent searches")
                                        .font(.system(.headline, weight: .semibold))
                                        .foregroundStyle(Color("TertiaryColor"))
                                }
                                Spacer()
                            }
                            Spacer()
                        }else{
                            ScrollView {
                                LazyVStack(spacing: 10) {
                                    ForEach(searchTextIsEmpty ? vm.searchHistory : vm.filteredStores) {store in
                                        SearchResult(store: store)
                                            .onTapGesture {
                                                // Dismiss Keyboard
                                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                
                                                
                                                if !vm.hasSelectedDestination {
                                                    vm.destStoreName = ""
                                                    destStore = Store()
                                                    vm.hasSelectedDestination = false
                                                    openSheet(store)
                                                    dismiss()
                                                }
                                                vm.setStoreFromDefault(store.name ?? "")
                                                vm.hasSelectedDestination = true
                                                
                                                if vm.trueIfStartStoreIsSelected {
                                                    vm.startStoreName = store.name ?? ""
                                                    vm.startStoreFloor = FloorAbbreviation.getFloorAbbreviation(floor: store.floor ?? "")
                                                    vm.hasSelectedStart = true
                                                    
                                                    if vm.hasSelectedDestination {
                                                        vm.trueIfStartStoreIsSelected = false
                                                        vm.trueIfDestStoreIsSelected = false
                                                    }
                                                    
                                                }else{
                                                    vm.destStoreName = store.name ?? ""
                                                    vm.destStoreFloor = FloorAbbreviation.getFloorAbbreviation(floor: store.floor ?? "")
                                                    
                                                    if vm.hasSelectedStart {
                                                        vm.trueIfStartStoreIsSelected = false
                                                        vm.trueIfDestStoreIsSelected = false
                                                    }
                                                }
                                            }
                                    }
                                }
                                .padding(.top, 10)
                            }
                            .redacted(reason: vm.isLoading ? .placeholder : [])
                        }
                    }
                }
                
                if vmNav.is2DMode {
                    VStack {
                        HStack {
                            Button(action: {
                                vmNav.is2DMode = false
                                vmNav.started = false
                            }){
                                Image(systemName: "chevron.left")
                                    .padding(20)
                                    .frame(width: 38, height: 38, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(.black.opacity(0.4))
                                    .cornerRadius(50)
                                Spacer()
                            }
                            .padding(20)
                        }
                        Spacer()
                    }
                    if vmNav.started == false {
                        Button(action: {
                            vmNav.started = true
                            let path = pathfinder.interEntities.map { simd_float3($0.position.x, $0.position.y + 0.1, $0.position.z) }
                            if path.count > 1 {
                                pathfinder2D.rotateCameraToFace(path[1])
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.000000001) {
                                    pathfinder2D.rotateCameraToFace(path[1])
                                }
                            } else {
                                pathfinder2D.rotateCameraToFace(path[0])
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.000000001) {
                                    pathfinder2D.rotateCameraToFace(path[0])
                                }
                            }
                            
                        }) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color.black)
                                    .opacity(0.3)
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(Color.blue600)
                                    .frame(width: 200, height: 50)
                                Text("Start Navigate")
                                    .foregroundColor(Color.white)
                                    .font(.headline)
                            }
                            
                        }
                        .environmentObject(pathfinder)
                        .environmentObject(pathfinder2D)
                    } else {
                        NavigateView()
                            .environmentObject(pathfinder)
                            .environmentObject(pathfinder2D)
                    }
                }
            }
            //        .background(.white)
            .navigationBarBackButtonHidden(true)
            .onAppear() {
                vm.destStoreName = self.destStore.name ?? ""
                vm.destStoreFloor = self.destStore.floor.map(FloorAbbreviation.getFloorAbbreviation) ?? ""
                
                if !vm.destStoreName.isEmpty {
                    vm.hasSelectedDestination = true
                }
            }
        }
    }
}
class NavigationViewModel: ObservableObject {
    @Published var is2DMode: Bool = false
    @Published var started: Bool = false
}

//#Preview {
//    SearchPageView{ _ in }
//}
