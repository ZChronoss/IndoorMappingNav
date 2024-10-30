//
//  NavigationSheetDetail.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 21/10/24.
//

import SwiftUI

struct NavigationSheetDetail: View {
    var body: some View {
        VStack {
            NavigationSheet(distance: 7)
            
            Divider()
            
            HStack {
                Text("Steps")
                    .font(.footnote)
                Spacer()
            }
            .padding(.top, 5)

            ScrollView {
                VStack(alignment: .leading) {
                    FirstStepCard(stepDescription: "Sociolla", imageStep: "Image1")
                    StepCard(iconImage: "arrow.up", stepDescription: "Keep going straight until you find Nike", imageStep: "Image1")
                    StepCard(iconImage: "arrow.right", stepDescription: "Going to the right side", imageStep: "Image1")
                    StepCard(iconImage: "arrow.up", stepDescription: "Keep going straight until you find escalator", imageStep: "Image1")
                    StepCard(iconImage: "figure.walk", stepDescription: "Go to the first floor through escalator", imageStep: "Image1")
                    StepCard(iconImage: "arrow.left", stepDescription: "Going to the left side", imageStep: "Image1")
                    StepCard(iconImage: "arrow.up", stepDescription: "Keep going straight", imageStep: "Image1")
                }
            }

        }
        .padding(.horizontal, 24)
        
        
    }
}

#Preview {
    NavigationSheetDetail()
}
