//
//  SearchBar.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 11/10/24.
//

import SwiftUI

struct SearchBar: View {
    @State private var searchText: String = ""

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search for a store...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(8)
                .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

#Preview {
    SearchBar()
}
