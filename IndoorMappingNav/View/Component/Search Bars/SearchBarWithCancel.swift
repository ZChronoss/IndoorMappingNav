//
//  SearchBarWithCancel.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 18/10/24.
//

import SwiftUI

struct SearchBarWithCancel: View {
    @FocusState var isActive: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            SearchBar(image: Image(systemName: "magnifyingglass"), iconColor: .secondary)
                .focused($isActive)
                .animation(.easeOut, value: isActive)
                .transition(.slide)
            
            if isActive {
                Button("cancel", action: {
                    withAnimation {
                        isActive.toggle()
                    }
                })
//                .animation(.linear, value: isActive)
                .transition(.move(edge: .trailing))
                
            }
        }
    }
}

#Preview {
    SearchBarWithCancel()
}
