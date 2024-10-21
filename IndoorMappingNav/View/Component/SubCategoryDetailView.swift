//
//  SubCategoryDetailView.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 14/10/24.
//

import SwiftUI

struct SubCategoryDetailView: View {
    var categoryName: String
    var subCategories: [SubCategory]

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                    ForEach(subCategories) { subCategory in
                        VStack {
                            Image(subCategory.image)
                                .resizable()
                                .scaledToFill() // Fill the space while maintaining aspect ratio
                                .frame(width: 115, height: 115) // Adjust the width and height
                                .clipped() // Ensure the image doesn't overflow the frame
                                .cornerRadius(12)
                                .padding(.bottom, 8)

                            Text(subCategory.name)
                                .font(.caption)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(categoryName)
    }
}

#Preview {
    SubCategoryDetailView(
        categoryName: "Food & Beverages",
        subCategories: [
            SubCategory(name: "Bakery", image: "Image1"),
            SubCategory(name: "Rice", image: "Image1"),
            SubCategory(name: "Fast Food", image: "Image1"),
            SubCategory(name: "Indonesian", image: "Image1"),
            SubCategory(name: "Japanese", image: "Image1")
        ]
    )
}
