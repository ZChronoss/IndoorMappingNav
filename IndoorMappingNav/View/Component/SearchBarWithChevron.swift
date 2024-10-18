//
//  SearchBarWithChevron.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 18/10/24.
//

import SwiftUI

struct SearchBarWithChevron: View {
    @FocusState var isActive: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            if isActive {
                Button(action: {
                    isActive.toggle()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                })
            }
            SearchBar()
                .focused(
                    withAnimation(.easeOut, {
                        $isActive
                    })
                )
                .animation(.easeOut, value: isActive)
                .transition(.slide)
        }
    }
}

#Preview {
    SearchBarWithChevron()
}
