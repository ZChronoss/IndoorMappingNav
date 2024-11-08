//
//  CategorySheet.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 21/10/24.
//

import SwiftUI

struct CategorySheet: View {
    var category: StoreCategory
    @Binding var categoryDetent: PresentationDetent // Receive binding
    @State private var isDetailViewActive = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                
                Rectangle()
                    .fill(Color.gray.opacity(0.5)) // Set color and opacity
                    .frame(width: 36, height: 5) // Width and height of the line
                    .cornerRadius(2) // Round the edges
                    .padding(.bottom, 16) // Add some bottom padding to separate from the content
                
                Spacer()
            }

            
            HStack(alignment: .center) {
                Text(category.name.rawValue) // Use the name from CategoryType
                    .font(Font.system(.title3))
                Spacer()
                Button(action: {
                    isDetailViewActive = true
                    categoryDetent = .fraction(0.75)
                }) {
                    Text("See All")
                        .font(Font.system(.caption2))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color("blue200"))
                .cornerRadius(12)
            }
            .padding(.bottom, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 32) {
                    SubCategoryTab(subCategories: category.subcategory ?? []) // Pass array of SubCategory
                }
            }
            .padding(.bottom, 16)

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 10) {
                    ForEach(category.subcategory ?? [], id: \.self) { item in
                        StoreCard(images: item.imageName) // Use imageName property
                    }
                }
                LongButton()
            }
            
            NavigationLink(
                destination: SubCategoryDetailView(
                    categoryName: category.name.rawValue,
                    subCategories: category.subcategory ?? []
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
    }
}

#Preview {
    @State var detent: PresentationDetent = .fraction(0.17) // Example state for preview

    NavigationStack {
        let category = StoreCategory(name: .fnb, subcategory: [.bakery, .rice, .fastFood]) // Example category
        CategorySheet(
            category: category,
            categoryDetent: $detent // Pass binding in preview
        )
    }
}
