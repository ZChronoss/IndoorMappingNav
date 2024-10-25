//
//  SwipingFinger.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 25/10/24.
//

import SwiftUI

struct SwipingFinger: View {
    @Binding var animationAmount: CGFloat
    
    // Define starting and ending positions
    let startingXPosition: CGFloat = 30 // Start 100 points from the left
    let endingXPosition: CGFloat = -100 // End 100 points to the left
    let startingYPosition: CGFloat = UIScreen.main.bounds.height / 3 // Vertical start position

    var body: some View {
        ZStack {
            // First image: fully visible at the start, fades out as animation progresses
            Image("finger2")
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 170)
                .opacity(1.0 - animationAmount) // Decreases from 1 to 0
        }
        // Adjust offset based on animationAmount and defined positions
        .offset(
            x: startingXPosition + (endingXPosition - startingXPosition) * animationAmount, // Calculate position based on animation amount
            y: startingYPosition // Keep vertical position constant or adjust as needed
        )
    }
}
