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
    @Binding var selectedCategory: String
    
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
                            Text("Jakarta Mall")
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
                }
                .sheet(isPresented: $vm.isCategorySheetOpen, onDismiss: {
                    // Clear the selected category when the sheet is dismissed
                    vm.moveDownEntitiesInCurrentCategory(selectedCategory) // Reset entities for this category
                    selectedCategory = ""
                    vm.updateCategory("") // Ensure the category is updated accordingly in the view model
                }) {
                    NavigationStack {
                        CategorySheet(categoryName: selectedCategory, categoryDetent: $vm.categoryDetent)
                    }
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
                                if selectedCategory == category.name.rawValue {
                                    // If clicking the same category, deselect it
                                    vm.updateCategory("")  // Update with empty string to clear selection
                                    selectedCategory = "" // Clear selectedCategory
                                    vm.isCategorySheetOpen = false // Close the category sheet
                                    vm.moveDownEntitiesInCategory(category.name.rawValue) // Reset entities for this category
                                } else {
                                    // Otherwise, select the new category
                                    vm.updateCategory(category.name.rawValue)
                                    selectedCategory = vm.selectedCategory
                                    vm.isCategorySheetOpen = true
                                    vm.moveEntitiesInCategory(category.name.rawValue, category.color.asUIColor)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 1)
                }
                .padding(.top, 8)
                .padding(.horizontal, 4)
                
                Spacer()  //Push the RealityView to the bottom
            }
        }
    }
}

#Preview {
    HomeView()
}

