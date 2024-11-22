//
//  CategorySheet.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 21/10/24.
//

import Foundation
import SwiftUI

struct CategorySheet: View {
    @Environment(\.dismiss) var dismiss
    
    var categoryName: String
    @StateObject private var viewModel = ViewModel()
    @Binding var categoryDetent: PresentationDetent // Receive binding
    @State private var isDetailViewActive = false
    
    @State private var isStoreSheetOpen = false
    @State private var selectedStore: Store? = nil
    
    var categoryColor: Color
    
    var action: (Store) -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text(categoryName)
                        .font(Font.system(.title3))
                    Spacer()
                    
                    // Show the "See All" button only if there are subcategories
                    if !viewModel.allSubCategories.isEmpty {
                        Button(action: {
                            isDetailViewActive = true
                            categoryDetent = .fraction(0.75)
                            print(categoryDetent)
                        }) {
                            Text("See All")
                                .font(Font.system(.caption2))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("Blue200"))
                        .cornerRadius(12)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 16)
                
                // Show the ScrollView for subcategories only if it contains items
                if !viewModel.allSubCategories.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 32) {
                            SubCategoryTab(subCategories: viewModel.allSubCategories, categoryColor: categoryColor, selectedSubCategory: $viewModel.selectedSubCategory)
                        }
                    }
                    .padding(.bottom, 16)
                }
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 500))], spacing: 10) {
                        ForEach(viewModel.filteredStores) { store in
                            StoreADACard(store: store, color: store.category?.color ?? .gray)
                                .onTapGesture {
                                    selectedStore = store
                                    isStoreSheetOpen = true
                                }
                            
                            //                        StoreCard(store: store, color: store.category?.color ?? .gray)
                            //                            .onTapGesture {
                            //                                print("Store Name \(store.name)")
                            //                                selectedStore = store
                            //                                isStoreSheetOpen = true
                            //                            }
                        }
                    }
                }
                //            .safeAreaPadding(.horizontal, 21)
                .safeAreaPadding(.vertical, 12)
                .navigationDestination(isPresented: $isDetailViewActive) {
                    SubCategoryDetailView(
                        categoryName: viewModel.storesByCategory.first?.category?.name.rawValue ?? "nil",
                        subCategories: viewModel.allSubCategories,
                        categoryDetent: $categoryDetent,
                        selectedSubCategory: $viewModel.selectedSubCategory
                    )
                }
                
//                NavigationLink(
//                    destination: SubCategoryDetailView(
//                        categoryName: viewModel.storesByCategory.first?.category?.name.rawValue ?? "nil",
//                        subCategories: viewModel.allSubCategories,
//                        categoryDetent: $categoryDetent,
//                        selectedSubCategory: $viewModel.selectedSubCategory
//                    ),
//                    isActive: $isDetailViewActive
//                ) {
//                    EmptyView()
//                }
            }
            .safeAreaPadding(.horizontal, 16)
            .padding(.top, 12)
            .sheet(isPresented: $isStoreSheetOpen) {
                if let store = selectedStore {
                    StoreDetailView(
                        store: store,
                        showRoute: { selectedStore in
                            // Implementasikan logika untuk menampilkan rute
                            action(selectedStore)
                            dismiss()
                            print("Route to \(selectedStore.name ?? "Unknown Store")")
                        }
                    )
                    .presentationDetents([.fraction(0.6)]) // Set detents ke 0.6
                }
            }
            .task {
                await viewModel.getStoreByCategory(categoryName)
                viewModel.getAllSubCategories()
            }
            .presentationDetents([.fraction(0.25), .fraction(0.75)])
        }
//        .presentationBackgroundInteraction(.enabled)
    }
}

#Preview {
    HomeView()
}
