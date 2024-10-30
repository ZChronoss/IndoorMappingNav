//
//  SearchBarWithCancel.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 18/10/24.
//

import SwiftUI

struct SearchBarWithCancel: View {
    @FocusState var isActive: Bool
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                SearchBar(searchText: $searchText, image: Image(systemName: "magnifyingglass"), iconColor: .secondary)
                    .focused($isActive)
                    .animation(.easeOut, value: isActive)
                    .transition(.slide)
                
                if isActive {
                    Button("Cancel", action: {
                        withAnimation {
                            isActive.toggle()
                        }
                        searchText = ""
                    })
                    .transition(.move(edge: .trailing))
                }
            }
            
            if isActive {
                withAnimation {
                    SearchPageView()                    
                }
            }
        }
    }
}

#Preview {
    SearchBarWithCancel(searchText: .constant(""))
}
