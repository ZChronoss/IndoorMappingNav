//
//  IconWithBorder.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 18/10/24.
//

import SwiftUI

struct IconWithBorder: View {
    var imageIcon: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
            
            Circle()
                .fill(Color.white)
                .opacity(0.8)
                .frame(width: 38, height: 38)
            
            Image(systemName: imageIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 17, height: 17)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    IconWithBorder(imageIcon: "location.fill")
}
