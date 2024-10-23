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
                    ForEach(subCategories, id: \.self) { subCategory in
                        VStack {
                            Image(subCategory.imageName) // Use computed property for image name
                                .resizable()
                                .scaledToFill() // Maintain aspect ratio while filling the space
                                .frame(width: 115, height: 115)
                                .clipped()
                                .cornerRadius(12)
                                .padding(.bottom, 8)

                            Text(subCategory.rawValue) // Use rawValue for display name
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
        subCategories: [.bakery, .rice, .fastFood, .indonesian, .japanese] // Use enum cases directly
    )
}
