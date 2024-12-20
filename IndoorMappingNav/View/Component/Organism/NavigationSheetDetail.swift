//
//  NavigationSheetDetail.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 21/10/24.
//

import SwiftUI
import RealityKit

struct NavigationSheetDetail: View {
    let instructions: [Directions]
    let pathCounts: Float
    let currentScene: Entity?
    
    var body: some View {
        VStack {
            let roundedDistance = max(Int(round(pathCounts / 1000)), 1)
            NavigationSheet(distance: roundedDistance, currentScene: currentScene)
            
            Divider()
            
            HStack {
                Text("Steps")
                    .font(.footnote)
                Spacer()
            }
            .padding(.top, 5)

            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(0 ..< instructions.count, id: \.self ) { idx in
                        StepCard(iconImage: instructions[idx].icon,
                                 direction: instructions[idx].instruction,
                                 store: instructions[idx].store,
                                 imageStep: "Image1",
                                 isLast: instructions[idx].id == instructions.last?.id
                        )
                    }
                }
            }

        }
        .padding(.horizontal, 24)
    }
}

//#Preview {
//    NavigationSheetDetail()
//}
