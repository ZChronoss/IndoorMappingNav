//
//  SubCategoryButton.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 14/10/24.
//

import SwiftUI

struct SubCategoryButton: View {
    var subCategoryName: String
    var image: String
    
    var body: some View {
        VStack() {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.bottom, 5)
            
            Text(subCategoryName)
                .font(.caption)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    SubCategoryButton(subCategoryName: "Bakery", image: "Image1")
}
