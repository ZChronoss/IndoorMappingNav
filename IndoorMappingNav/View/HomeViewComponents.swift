//
//  HomeViewComponents.swift
//  IndoorMappingNav
//
//  Created by Leonardo Marhan on 30/10/24.
//

import SwiftUI

struct HomeViewComponents: View {
    @EnvironmentObject var vm: HomeViewModel

    @State var isSheetOpen = false
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
                    .presentationDetents([.fraction(0.17), .fraction(0.8)]) // Initial small size (0.17), expandable to larger size (0.5)
                    .presentationBackgroundInteraction(.enabled)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(vm.categories, id: \.name) { category in
                            CategoryButton(
                                categoryName: category.name.rawValue,
                                categoryImage: Image(category.image ?? "questionmark"), // Gunakan Image() di sini
                                categoryColor: category.color,
                                isSelected: selectedCategory == category.name.rawValue
                            ) {
                                vm.updateCategory(category.name.rawValue)
                                selectedCategory = vm.selectedCategory
                                vm.isCategorySheetOpen = true
                                vm.moveEntitiesInCategory(category.name.rawValue, category.color.asUIColor)
                            }
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

