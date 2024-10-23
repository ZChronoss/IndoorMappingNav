//
//  TapSearchBarButton.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 23/10/24.
//

import SwiftUI

struct TapSearchBarButton: View {
    var text: String
    
    var body: some View {
        Button(action: {
            
        }) {
            Text(text)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.blue)
        )
    }
}

#Preview {
    TapSearchBarButton(text: "Recent")
}
