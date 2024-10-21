//
//  JumpToEndInstructionButton.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 17/10/24.
//

import SwiftUI

struct JumpToEndButton: View {
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.black) // Sesuain ama Color Asset -> Neutral 2
                
                Text("Jump to End")
                    .font(.footnote)
                    .foregroundColor(.black) // Sesuain ama Color Asset -> Neutral 2
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(Color(red: 0.4, green: 0.6, blue: 1.0)) // Sesuain ama Color Asset -> Blue 300
            .cornerRadius(100)
        }
    }
}

#Preview {
    JumpToEndButton()
}
