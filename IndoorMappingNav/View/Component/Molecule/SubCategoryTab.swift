//
//  SubCategoryTab.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 21/10/24.
//

import SwiftUI

struct SubCategoryTab: View {
    var subCategories: [SubCategory] // Changed to accept an array of SubCategory
    
    @State private var selectedCategory: SubCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 32) {
                ForEach(subCategories, id: \.self) { item in
                    SpecificCategory(
                        subCategoryName: item.rawValue, // Use the raw value of the enum
                        image: item.imageName, // Assume image name is a computed property of the enum
                        isSelected: selectedCategory == item,
                        onSelect: {
                            selectedCategory = item
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 2)
            .frame(height: 74)
        }
    }
}

#Preview {
    // Provide example subcategories for the preview
    SubCategoryTab(subCategories: [.bakery, .rice, .fastFood]) // Pass in example subcategories
}
