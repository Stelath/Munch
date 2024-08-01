//
//  SplashScreenView.swift
//  Munch
//
//  Created by John Severson on 7/1/24.
//

import SwiftUI


struct SplashScreenView: View {
    @State private var mouthImages = ["Closed mouth", "MouthOpenish", "Mouth", "MouthOpen", "MunchNoBack"] // Add your mouth image names here
    @State private var currentMouthIndex = 0
    @State private var mouthScale: CGFloat = 0.0
    @State private var timer: Timer?
    @State private var drumstickOffset: CGFloat = -UIScreen.main.bounds.height / 2
    @State private var drumstickOpacity: Double = 1.0
    @State private var animationCompleted = false



    var body: some View {
        if animationCompleted {
            withAnimation(.easeInOut(duration: 0.5)) {
                RoomView()
            }
            
        } else {
            ZStack {
                Image(mouthImages[currentMouthIndex])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .padding()
                    .scaleEffect(mouthScale)
                    .opacity(mouthScale == 0.0 ? 1.0 : 1.0) // Always visible during scaling
                    .onAppear {
                        startMouthAnimation()
                    }
                Image("Drumstick")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .scaleEffect(0.72)
                    .offset(y: drumstickOffset)
                    .opacity(drumstickOpacity)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 175)
                
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }
    
    
    private func startMouthAnimation() {
        let durations: [Double] = [1.0, 1.0, 1.0, 1.0, 1.0] // Adjust durations as needed
        let scales: [CGFloat] = [0.1, 0.14, 0.16, 0.18, 0.2]

        timer = Timer.scheduledTimer(withTimeInterval: 1.1, repeats: true) { _ in
            withAnimation(.easeInOut(duration: durations[currentMouthIndex])) {
                mouthScale = scales[currentMouthIndex]
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + durations[currentMouthIndex]) {
                if currentMouthIndex < mouthImages.count - 1 {
                    currentMouthIndex += 1
                    mouthScale = scales[currentMouthIndex - 1]
                } else {
                    timer?.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.72)) {
                            animationCompleted = true // Trigger navigation after animation completes
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeIn(duration: 3.3)) {
                drumstickOffset = UIScreen.main.bounds.height / 2.87 - 175
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.32) {
                withAnimation(.easeOut) {
                    drumstickOpacity = 0.0
                }
            }
        }
    }
}

    

#Preview {
    SplashScreenView()
}
