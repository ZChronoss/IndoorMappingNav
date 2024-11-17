//
//  SearchBarWithCancel.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 18/10/24.
//

import SwiftUI

struct SearchBarWithCancel: View {
    enum FocusedField {
        case textField
    }
    
    @Environment(\.dismiss) var dismiss
    @FocusState var isActive: Bool
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                SearchBar(searchText: $searchText, image: Image(systemName: "magnifyingglass"), iconColor: .secondary)
                    .focused($isActive)
                    .animation(.easeOut, value: isActive)
                    .transition(.slide)
                
                Button("Cancel", action: {
                    dismiss()
                })
            }
        }
        .onAppear() {
            isActive = true
        }
    }
}

#Preview {
    SearchBarWithCancel(searchText: .constant(""))
}
