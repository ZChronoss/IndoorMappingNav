//
//  HomeViewComponents.swift
//  IndoorMappingNav
//
//  Created by Leonardo Marhan on 30/10/24.
//

import SwiftUI

struct HomeViewComponents: View {
    @EnvironmentObject var vm: HomeViewModel
    @StateObject var mapLoader = MapLoader.shared
    @StateObject var csVM = CategorySheet.ViewModel()
    
    @State var isSheetOpen = false
    @Binding var selectedCategory: String
    @State private var selectedOption: String = "Apple Developer Academy"
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .top) {
                    // White background rectangle
                    CustomCornerShape(radius: 20, corners: [.bottomLeft, .bottomRight])
                        .fill(Color("WhiteBG"))
                        .shadow(color: Color("StatusBar").opacity(0.1), radius: 5, x: 0, y: 10)
                        .frame(height: 95) // Adjust this value to control how far down the rectangle extends
                        .zIndex(0)
                    
                    VStack(spacing: 0) {
                        DropdownView(selectedOption: $selectedOption)
                            .background(Color("WhiteBG"))
                            .cornerRadius(10)
                            .environmentObject(vm)
                        
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
                    .presentationDetents([.fraction(0.55)])
                    //                    .presentationBackgroundInteraction(.enabled)
                }
                .sheet(isPresented: $vm.isCategorySheetOpen, onDismiss: {
                    // Clear the selected category when the sheet is dismissed
                    vm.moveDownEntitiesInCurrentCategory(selectedCategory) // Reset entities for this category
                    selectedCategory = ""
                    vm.updateCategory("") // Ensure the category is updated accordingly in the view model
                    
                    
                }) {
                    NavigationStack {
                        CategorySheet(categoryName: selectedCategory, categoryDetent: $vm.categoryDetent, categoryColor: vm.categories.first(where: { $0.name.rawValue == selectedCategory })?.color ?? .gray) {store in
                            
                            vm.selectedDestination = store
                            vm.isSearching = true
                            vm.isCategorySheetOpen = false
                            
                        }
                    }
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(vm.categories, id: \.name) { category in
                            CategoryButton(
                                categoryName: category.name.rawValue,
                                categoryImage: Image(systemName: category.image ?? "ellipsis"), // Gunakan Image() di sini
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

