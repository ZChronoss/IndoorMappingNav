//
//  StepsCard.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 18/10/24.
//

import SwiftUI

struct StepCard: View {
    var iconImage: String
    var imageStep: String
    
    var body: some View {
        HStack {
            HStack(spacing: 16) {
                Image(systemName: iconImage)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("Keep going straight until you find Nike")
                    .font(.body)
                    .frame(width: 213)
            }
            
            Spacer()
            
            Image(imageStep)
                .resizable()
                .clipped()
                .frame(width: 66)
        }
        .frame(height: 41)
        .padding(.vertical, 16)
        
        Divider()
    }
}

#Preview {
    StepCard(iconImage: "arrow.up", imageStep: "Image3")
}
