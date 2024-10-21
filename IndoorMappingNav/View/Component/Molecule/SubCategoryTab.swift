//
//  SubCategoryTab.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 21/10/24.
//

import SwiftUI

struct SubCategoryTab: View {
    var subCategory: [SubCategory] = [
        SubCategory(name: "Bakery", image: "Image1"),
        SubCategory(name: "Rice", image: "Image1"),
        SubCategory(name: "Fast Food", image: "Image1"),
        SubCategory(name: "Indonesian", image: "Image1"),
        SubCategory(name: "Japanese", image: "Image1"),
        SubCategory(name: "Japanese", image: "Image1"),
        SubCategory(name: "Japanese", image: "Image1")
    ]
    
    @State private var selectedCategory: SubCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 32) {
                ForEach(subCategory) { item in
                    SpecificCategory(
                        subCategoryName: item.name,
                        image: item.image,
                        isSelected: selectedCategory?.id == item.id,
                        onSelect: {
                            selectedCategory = item
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    SubCategoryTab()
}
