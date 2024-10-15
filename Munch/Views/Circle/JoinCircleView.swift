//
//  JoinCircleView.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import SwiftUI

struct JoinCircleView: View {
    @StateObject private var viewModel = JoinCircleViewModel()
    @State private var navigateToSwipe = false
    @State private var currentCircleId: UUID?

    var body: some View {
        VStack {
            Text("Join a Circle")
                .font(.largeTitle)
                .padding()
            
            TextField("Name", text: $viewModel.name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.words)
            
            TextField("Enter Circle Code", text: $viewModel.circleCode)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.allCharacters)
                .disableAutocorrection(true)

            Button(action: {
                viewModel.joinCircle()
            }) {
                Text("Join Circle")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            if viewModel.isLoading {
                ProgressView("Joining Circle...")
                    .padding()
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            if viewModel.isWaitingToStart {
                VStack {
                    Text("Waiting for circle to start...")
                        .font(.headline)
                        .padding(.bottom)

                    if !viewModel.joinedUsers.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Joined Users")
                                .font(.headline)

                            ForEach(viewModel.joinedUsers) { user in
                                Text(user.name)
                                    .padding(.vertical, 2)
                            }
                        }
                        .padding()
                    }
                }
                .padding()
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Join Circle")
    }
}

#Preview {
    JoinCircleView()
}
