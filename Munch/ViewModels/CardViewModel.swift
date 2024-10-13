//
//  CardViewModel.swift
//  Munch
//
//  Created by Mac Howe on 10/13/24.
//

import SwiftUI
import MapKit

class CardViewModel: ObservableObject, Identifiable {
    @Published var card: Card
    @Published var lookAroundScene: MKLookAroundScene?
    @Published var position: CGSize = .zero
    @Published var rotation: Double = 0.0
    
    let id = UUID()

    init(card: Card) {
        self.card = card
        fetchLookAroundPreview()
    }

    var likeOpacity: Double {
        Double(position.width / 10 - 1)
    }

    var dislikeOpacity: Double {
        Double(position.width / 10 * -1 - 1)
    }

    func fetchLookAroundPreview() {
        lookAroundScene = nil
        Task { [weak self] in
            guard let self else { return }
            do {
                let request = MKLookAroundSceneRequest(mapItem: card.mapItem)
                let scene = try await request.scene
                await MainActor.run {
                    self.lookAroundScene = scene
                }
            } catch {
                print("Failed to fetch Look Around scene: \(error.localizedDescription)")
            }
        }
    }

    func onDragChanged(value: DragGesture.Value) {
        withAnimation(.default) {
            position = value.translation
            rotation = 7 * (value.translation.width > 0 ? 1 : -1)
        }
    }


    func onDragEnded(value: DragGesture.Value) -> SwipeDirection? {
        var swipeDirection: SwipeDirection? = nil

        if value.translation.width > 100 {
            // Swiped right
            performSwipe(direction: .right, isUserInitiated: true)
            swipeDirection = .right
        } else if value.translation.width < -100 {
            // Swiped left
            performSwipe(direction: .left, isUserInitiated: true)
            swipeDirection = .left
        } else {
            // Return to original position
            withAnimation(.spring()) {
                position = .zero
                rotation = 0
            }
        }
        return swipeDirection
    }

    func performSwipe(direction: SwipeDirection, isUserInitiated: Bool = false, completion: (() -> Void)? = nil) {
        withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
            position.width = direction == .left ? -500 : 500
            rotation = direction == .left ? -12 : 12
        }
        if isUserInitiated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                completion?()
            }
        } else {
            completion?()
        }
    }
}


