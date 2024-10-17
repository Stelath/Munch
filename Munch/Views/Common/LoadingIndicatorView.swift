//
//  LoadingIndicatorView.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//


import SwiftUI

struct LoadingIndicatorView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .padding()
    }
}
