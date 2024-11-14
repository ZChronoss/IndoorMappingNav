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
    var placeholder: LocalizedStringKey = "Search for a store name"
    var label: String = ""
    
    var body: some View {
        HStack() {
            image
                .foregroundStyle(iconColor)
                .bold()
            TextField(placeholder, text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .autocorrectionDisabled()
                .padding(8)
                .cornerRadius(16)
                .truncationMode(.tail)
            Label(label.isEmpty ? "" : label, systemImage: label.isEmpty ? "microphone.fill" : "")
                .foregroundColor(Color("SecondaryColor")) // Set warna mikrofon
                .font(label.isEmpty ? .headline : .system(.caption, weight: .bold))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color("BGnSB"))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

#Preview {
    SearchBar(searchText: .constant("Haankdnawkldnakwdnkaldnklawdnlkaanlkankldadnklmdaklmd"), image: Image(systemName: "magnifyingglass"), iconColor: .secondary)
}
