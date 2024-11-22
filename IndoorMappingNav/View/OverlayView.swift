//
//  OverlayView.swift
//  IndoorMappingNav
//
//  Created by Michael Varian Kostaman on 25/10/24.
//

import SwiftUI

struct OverlayView: View {
    @Binding var isOverlayVisible: Bool // Control for dismissing overlay
    @State private var animationAmount: CGFloat = 1.0 // Skip first loop by starting at 1.0

    var body: some View {
        ZStack {
            // Semi-transparent black overlay
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            // Finger swipe animation view
            SwipingFinger(animationAmount: $animationAmount)
        }
        .onTapGesture {
            // Dismiss overlay on tap
            isOverlayVisible = false
        }
        .task {
            await startAnimationLoop() // Start the continuous loop
        }
    }

    // Async function to control the animation loop
    private func startAnimationLoop() async {
        while isOverlayVisible {
            // Set the animationAmount to 0.0 instantly to skip the first animation
            animationAmount = 0.0

            // Run the normal animation loop from this point onward
            await animateSwipe()
        }
    }

    // Smooth swipe animation
    private func animateSwipe() async {
        withAnimation(
            Animation.easeInOut(duration: 3) // Smooth 3-second animation
        ) {
            animationAmount = 1.0
        }

        // Pause for 1 second before restarting the loop
        try? await Task.sleep(nanoseconds: 1_300_000_000)

        // Reset the animation state before restarting the loop
        animationAmount = 0.0
    }
}
