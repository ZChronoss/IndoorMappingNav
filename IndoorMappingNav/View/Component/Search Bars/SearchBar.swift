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
    var backgroundColor: Color = Color("BGnSB")
    
    var body: some View {
        HStack(alignment: .center) {
            image
                .foregroundStyle(iconColor)
                .bold()
                .scaledToFit()
            TextField(placeholder, text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .autocorrectionDisabled()
                .truncationMode(.tail)
                .font(.inputFieldText)
            if label.isEmpty {
                Image(systemName: "microphone.fill")
                    .frame(height: 20)
                    .scaledToFit()
                    .foregroundStyle(Color("SecondaryColor"))
            }else{
                Text(label)
                    .font(.system(.caption, weight: .bold))
                    .foregroundStyle(Color("SecondaryColor"))
            }
//            Label(label.isEmpty ? "" : label, systemImage: label.isEmpty ? "microphone.fill" : "")
//                .foregroundColor(Color("SecondaryColor")) // Set warna mikrofon
////                .frame(width: 17, height: 20)
//                .font(.system(.caption, weight: .bold))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(backgroundColor)
        .cornerRadius(9)
        .shadow(radius: 2)
    }
}

#Preview {
    SearchBar(searchText: .constant("Haankdnawkldnakwdnkaldnklawdnlkaanlkankldadnklmdaklmd"), image: Image(systemName: "magnifyingglass"), iconColor: .secondary)
}
