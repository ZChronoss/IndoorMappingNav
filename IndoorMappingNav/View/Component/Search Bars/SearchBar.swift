//
//  SearchBar.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 11/10/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var image: Image
    var iconColor: Color
    
    var body: some View {
        HStack() {
            image
                .foregroundStyle(iconColor)
                .bold()
            TextField("Search for a store...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .autocorrectionDisabled()
                .padding(8)
                .cornerRadius(16)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

#Preview {
    SearchBar(searchText: .constant("Ha"), image: Image(systemName: "magnifyingglass"), iconColor: .secondary)
}
