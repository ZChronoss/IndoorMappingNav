//
//  FirstStepCard.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 21/10/24.
//

import SwiftUI

struct FirstStepCard: View {
    var stepDescription: String
    var imageStep: String
    
    var body: some View {
        HStack {
            HStack(spacing: 16) {
                Image(systemName: "location.fill")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                
                Text(stepDescription)
                    .font(.body)
                    .frame(width: 213, alignment: .leading)
            }
            
            Spacer()
            
            Image(imageStep)
                .resizable()
                .clipped()
                .frame(width: 66)
        }
        .frame(height: 41)
        .padding(.bottom, 16)
        
        Divider()
    }
}

#Preview {
    FirstStepCard(stepDescription: "Sociolla", imageStep: "Image3")
}
