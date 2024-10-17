//
//  ErrorView.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import SwiftUI

struct ErrorView: View {
    let message: String

    var body: some View {
        Text(message)
            .foregroundColor(.red)
            .padding()
    }
}
