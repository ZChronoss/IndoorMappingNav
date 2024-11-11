//
//  HomeViewComponents.swift
//  IndoorMappingNav
//
//  Created by Leonardo Marhan on 30/10/24.
//

import SwiftUI

struct HomeViewComponents: View {
    @EnvironmentObject var vm: HomeViewModel
    
    // Ini yang jalan
//    @StateObject private var vm: HomeViewModel
//
//    init() {
//        _vm = StateObject(wrappedValue: HomeViewModel(scene: nil))
//    }
    
    
    @State var isSheetOpen = false
//    @State private var selectedCategory: String = "Food & Beverage"
    
    @Binding var selectedCategory: String  // Add this
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .top) {
                    // White background rectangle
                    CustomCornerShape(radius: 20, corners: [.bottomLeft, .bottomRight])
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 10)
                        .frame(height: 95) // Adjust this value to control how far down the rectangle extends
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("Summarecon Mall Serpong")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color("TextIcon"))
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color("TextIcon"))
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                        
                        SearchBar(searchText: .constant(""), image: Image(systemName: "magnifyingglass"), iconColor: Color("SecondaryColor"))
                            .padding(.horizontal, 20)
                            .disabled(true)
                            .onTapGesture {
                                vm.selectedDestination = Store()
                                vm.isSearching = true
                                isSheetOpen = false
                            }
                            .navigationDestination(isPresented: $vm.isSearching) {
                                SearchPageView(destStore: vm.selectedDestination ?? Store()) { store in
                                    vm.selectedStore = store
                                    vm.storeName = store.name ?? ""
                                    isSheetOpen = true
                                }
                            }
                    }
                }
                .sheet(isPresented: $isSheetOpen) {
                    StoreDetailView(store: vm.selectedStore ?? Store()) { store in
                        vm.selectedDestination = store
                        vm.isSearching = true
                        isSheetOpen = false
                    }
                    .presentationDetents([.fraction(0.5)])
                    .presentationBackgroundInteraction(.enabled)
                }
                .sheet(isPresented: $vm.isCategorySheetOpen) {
                    NavigationStack {
                        CategorySheet(categoryName: selectedCategory, categoryDetent: $vm.categoryDetent)
                    }
                }
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryButton(categoryName: "Food & Beverage", categoryIcon: "fork.knife", categoryColor: .red, isSelected: selectedCategory == "Food & Beverage") {
                            vm.updateCategory("Food & Beverage")
                            selectedCategory = vm.selectedCategory
                            vm.isCategorySheetOpen = true
                            vm.moveEntitiesInCategory("Food & Beverage")
                        }
                        CategoryButton(categoryName: "Shopping", categoryIcon: "cart", categoryColor: .green, isSelected: selectedCategory == "Shopping") {
                            vm.updateCategory("Shopping")
                            selectedCategory = vm.selectedCategory
                            vm.isCategorySheetOpen = true
                            vm.moveEntitiesInCategory("Shopping")
                        }
                        CategoryButton(categoryName: "Entertainment", categoryIcon: "gamecontroller", categoryColor: .purple, isSelected: selectedCategory == "Entertainment") {
                            vm.updateCategory("Entertainment")
                            selectedCategory = vm.selectedCategory
                            vm.isCategorySheetOpen = true
                            vm.moveEntitiesInCategory("Entertainment")
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 16)
                
                Spacer()  //Push the RealityView to the bottom
            }
        }
    }
}

//#Preview {
//    HomeViewComponents()
//}

