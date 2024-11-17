//
//  SubCategoryCard.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 17/10/24.
//

import SwiftUI

struct SubCategoryCard: View {
    
//    var subCategory: SubCategory
    var subCategoryName: String
    var image: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 115, height: 115)
                .cornerRadius(12)
            
            Text(subCategoryName)
                .font(.caption)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    SubCategoryCard(subCategoryName: "Bakery", image: "Image4")
}
