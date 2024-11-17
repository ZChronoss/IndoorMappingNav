//
//  StepsCard.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 18/10/24.
//

import SwiftUI

struct StepCard: View {
    var iconImage: String
    var direction: LocalizedStringResource
    var store: String
    var imageStep: String
    
    var isLast: Bool
    
    var body: some View {
        HStack {
            HStack(spacing: 16) {
                Image(systemName: iconImage)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                if isLast {
                    Text("\(direction) and you have arrived at **\(store)**")
                        .font(.body)
                        .frame(alignment: .leading)
                } else {
                    Text("\(direction) and you will see **\(store)**")
                        .font(.body)
                        .frame(alignment: .leading)
                }
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

//#Preview {
//    StepCard(iconImage: "arrow.up", direction: "Sociolla", store: "miniso", imageStep: "Image3")
//}
