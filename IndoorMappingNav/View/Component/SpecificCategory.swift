//
//  SpecificCategory.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 17/10/24.
//

import SwiftUI

struct SpecificCategory: View {
    var subCategoryName: String
    var image: String
    var isSelected: Bool
    var onSelect: () -> Void
    var categoryColor: Color
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 47, height: 47)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSelected ? categoryColor : Color.clear, lineWidth: 3)
                )
                .padding(.bottom, 5)
                .onTapGesture {
                    onSelect()
                }
            
            Text(subCategoryName)
                .font(.caption)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(Color("TextIcon"))
        }
        .animation(.easeInOut, value: isSelected)
    }
}

//#Preview {
//    SpecificCategory(subCategoryName: "Bakery", image: "Image1", isSelected: true, onSelect: {})
//}

#Preview {
    HomeView()
}
