//
//  NavigationView.swift
//  IndoorMappingNav
//
//  Created by Leonardo Marhan on 30/10/24.
//

import SwiftUI

struct NavigateView: View {
    @EnvironmentObject var pathfinder2D: PathfindingService2D
    @EnvironmentObject var pathfinder: PathfindingService
    @State private var focusedCard: Int = 0
    
    var body: some View {
        VStack {
            Spacer()
            InstructionList(instructions: pathfinder.instructions, focusedCard: $focusedCard)
//            NavigationSheetDetail(instructions: pathfinder.instructions, pathCounts: pathfinder.pathCounts)
        }
        .onChange(of: focusedCard) { _, newCardIndex in
            pathfinder2D.moveObject(to: newCardIndex)
        }
    }
}

#Preview {
    NavigateView()
}

