//
//  CategoryStoreCard.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 16/10/24.
//

import SwiftUI

struct SubCategoryCard: View {
    var subCategory: SubCategory

    var body: some View {
        VStack {
            Image(subCategory.image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 159, maxHeight: 115) // Fixed height
                .clipped()
                .cornerRadius(12)

            Text(subCategory.name)
                .font(.headline)
                .foregroundColor(.primary)

            // You can add additional details below the name
            Text("Subcategory Type") // Change this to the actual detail, e.g., "Japanese Food"
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding() // Padding around each card
        .background(Color.white) // Background color for the card
        .cornerRadius(12) // Rounded corners
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2) // Shadow effect
    }
}
