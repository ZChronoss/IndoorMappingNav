//
//  SearchBar+Back.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 18/10/24.
//

import SwiftUI

struct SearchBarWithBack: View {
    @State private var searchText: String = ""

    var body: some View {
        HStack {
            Image(systemName: "chevron.backward")
                .font(.body)
                .fontWeight(.bold)
                .padding(.trailing, 16)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search for a store...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
                    .cornerRadius(8)
                
                Image(systemName: "microphone.fill")
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 4)
        }
        

    }
}

#Preview {
    SearchBarWithBack()
}
