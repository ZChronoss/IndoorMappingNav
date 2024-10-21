//
//  CategorySheet.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 21/10/24.
//

import SwiftUI

struct CategorySheet: View {
    var categoryName: String
    var subCategory: [SubCategory] = [
        SubCategory(name: "Bakery", image: "Image1"),
        SubCategory(name: "Rice", image: "Image1"),
        SubCategory(name: "Fast Food", image: "Image1"),
        SubCategory(name: "Indonesian", image: "Image1"),
        SubCategory(name: "Japanese", image: "Image1")
    ]
    
    @Binding var categoryDetent: PresentationDetent // Receive binding
    @State private var isDetailViewActive = false
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack (alignment: .center) {
                Text(categoryName)
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
                HStack (spacing: 32) {
                    SubCategoryTab()
                }
            }
            .padding(.bottom, 16)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 10) {
                    ForEach(subCategory) { item in
                        StoreCard(images: item.image)
                    }
                }
            }
            
            NavigationLink(
                destination: SubCategoryDetailView(
                    categoryName: categoryName,
                    subCategories: subCategory
                ),
                isActive: $isDetailViewActive
            ) {
                EmptyView()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 41)
    }
}

#Preview {
    @State var detent: PresentationDetent = .fraction(0.17) // Example state for preview

    return NavigationStack {
        CategorySheet(
            categoryName: "Food & Beverages",
            categoryDetent: $detent // Pass binding in preview
        )
    }
}
