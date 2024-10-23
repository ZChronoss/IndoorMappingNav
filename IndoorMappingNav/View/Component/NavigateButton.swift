//
//  ButtonNavigate.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 21/10/24.
//

import SwiftUI

struct NavigateButton: View {
    var actionNavigate: (() -> Void)?
    
    var body: some View {
        Button(action: {
            actionNavigate?()
            }) {
                HStack {
                    Image(systemName: "location.north.fill")

                    Text("Navigate")
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.blue)
            )
            .foregroundColor(.white)
    }
}

#Preview {
    NavigateButton()
}
