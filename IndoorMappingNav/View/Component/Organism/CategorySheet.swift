//
//  CategorySheet.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 21/10/24.
//

import Foundation
import SwiftUI

struct CategorySheet: View {
    var categoryName: String
    @StateObject private var viewModel = ViewModel()
    @Binding var categoryDetent: PresentationDetent // Receive binding
    @State private var isDetailViewActive = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("")
            }
//            .padding(.top, 10)

            
            HStack(alignment: .center) {
                Text(categoryName)
                    .font(Font.system(.title3))
                Spacer()

                // Show the "See All" button only if there are subcategories
                if !viewModel.allSubCategories.isEmpty {
                    Button(action: {
                        isDetailViewActive = true
                        categoryDetent = .fraction(0.75)
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
            .padding(.top, categoryDetent == .fraction(0.17) ? 30 : 0)
            .padding(.bottom, 16)

            // Show the ScrollView for subcategories only if it contains items
            if !viewModel.allSubCategories.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 32) {
                        SubCategoryTab(subCategories: viewModel.allSubCategories)
                    }
                }
                .padding(.bottom, 16)
            }

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 10) {
                    ForEach(viewModel.storesByCategory) { store in
                        StoreCard(store: store, color: store.category?.color ?? .gray) // Pass store to StoreCard
                    }
                }
            }
            
            NavigationLink(
                destination: SubCategoryDetailView(
                    categoryName: viewModel.storesByCategory.first?.category?.name.rawValue ?? "nil",
                    subCategories: viewModel.allSubCategories
                ),
                isActive: $isDetailViewActive
            ) {
                EmptyView()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .task {
            await viewModel.getStoreByCategory(categoryName)
            await viewModel.getAllSubCategories()
        }
        .presentationDetents([.fraction(0.17), .fraction(0.75)])
//        .presentationBackgroundInteraction(.enabled)
    }
}

//#Preview {
//    @State var detent: PresentationDetent = .fraction(0.17) // Example state for preview
//
//    NavigationStack {
//        let category = StoreCategory(name: .fnb, subcategory: [.bakery, .rice, .fastFood]) // Example category
//        CategorySheet(
//            categoryName: "Food & Beverages",
//            categoryDetent: $detent // Pass binding in preview
//        )
//    }
//}

#Preview {
    HomeView()
}
