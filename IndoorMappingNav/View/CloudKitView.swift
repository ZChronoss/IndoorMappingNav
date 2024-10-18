////
////  CloudKitView.swift
////  IndoorMappingNav
////
////  Created by Renaldi Antonio on 14/10/24.
////
//
//import SwiftUI
//import CloudKit
//
//struct CloudKitView: View {
//    @StateObject private var viewModel = ViewModel()
//    
//    var body: some View {
//        NavigationView {
//            Text((viewModel.stores.first?.address) ?? "Gaada")
//        }
//        .onAppear() {
//            Task {
//                await viewModel.fetchStores()
//            }
//        }
//    }
//}
//
//extension CloudKitView {
//    class ViewModel: ObservableObject {
//        @Published var stores: [Store] = []
//        private var cloudKitController = CloudKitController()
//        
//        func fetchStores() async {
//            stores = try! await cloudKitController.fetchStores()
//        }
//    }
//}
//
//#Preview {
//    CloudKitView()
//}
