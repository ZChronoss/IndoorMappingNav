//
//  CategoryButton.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 04/10/24.
//

import SwiftUI

struct CategoryButton: View {
    var categoryName: String
    var categoryImage: Image
    var categoryColor: Color
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                categoryImage
                    .resizable()  // Membuat gambar dapat diubah ukurannya
                    .frame(width: 20, height: 20) 
                    .foregroundColor(isSelected ? .white : categoryColor)
                Text(categoryName)
                    .foregroundColor(isSelected ? .white : categoryColor)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? categoryColor : Color("BGnSB"))
                    .shadow(color: isSelected ? .clear : Color.black.opacity(0.25), radius: 2, x: 0, y: 0)
            )
            
        }
    }
}

#Preview {
    CategoryButton(
        categoryName: "Food & Beverage",
        categoryImage: Image("foodAndBev"),  // Gunakan Image(systemName:)
        categoryColor: .red,
        isSelected: false,
        action: {}
    )
}

