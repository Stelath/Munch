//
//  CardViewModel.swift
//  Munch
//
//  Created by Mac Howe on 10/13/24.
//

import SwiftUI
import MapKit

class RestaurantViewModel: ObservableObject, Identifiable {
    @Published var restaurant: Restaurant
    @Published var lookAroundScene: MKLookAroundScene?
    @Published var position: CGSize = .zero
    @Published var rotation: Double = 0.0

    let id = UUID()

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        fetchLookAroundPreview()
    }

    var likeOpacity: Double {
        Double(max(min(position.width / 10 - 1, 1), 0))
    }

    var dislikeOpacity: Double {
        Double(max(min(-position.width / 10 - 1, 1), 0))
    }

    func fetchLookAroundPreview() {
        lookAroundScene = nil
        Task { [weak self] in
            guard let self else { return }
            do {
                let request = MKLookAroundSceneRequest(mapItem: restaurant.mapItem)
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
        if abs(value.translation.width) > 100 {
            let direction: SwipeDirection = value.translation.width > 0 ? .right : .left
            performSwipe(direction: direction, isUserInitiated: true)
            return direction
        } else {
            withAnimation(.spring()) {
                position = .zero
                rotation = 0
            }
            return nil
        }
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
