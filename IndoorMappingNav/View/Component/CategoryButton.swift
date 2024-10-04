//
//  CategoryButton.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 04/10/24.
//

import SwiftUI

struct CategoryButton: View {
    var categoryName: String
    var categoryIcon: String
    var categoryColor: Color
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: categoryIcon)
                    .foregroundColor(isSelected ? .white : categoryColor)
                Text(categoryName)
                    .foregroundColor(isSelected ? .white : categoryColor)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? categoryColor : Color.white)
            )
            
        }
    }
}

#Preview {
    CategoryButton(categoryName: "Food & Beverage", categoryIcon: "fork.knife", categoryColor: .red, isSelected: true, action: {})
}

