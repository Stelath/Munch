//
//  CreateCircleView.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import SwiftUI

struct CreateCircleView: View {
    @StateObject private var viewModel = CreateCircleViewModel()
    // Assume you have a way to obtain the current user's UUID
    let userId: String = generateDummyID() // Replace with actual user ID retrieval - May hash it from the username they pick for now
    
    var body: some View {
        VStack {
            Text("Create a Circle")
                .font(.largeTitle)
                .padding()

            TextField("Name", text: $viewModel.name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                //TODO: How many restaurants to pick from and pick a new location - mac
            TextField("Location", text: $viewModel.location)
                       .padding()
                       .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: {
                    viewModel.createCircle()
                }) {
                    Text("Create Circle")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            
            // TODO: Sharing code button
            if let code = viewModel.generatedCode {
                Text("Circle Code: \(code)")
                    .font(.title2)
                    .padding()
                    .fontWeight(.bold)
            }

            if !viewModel.joinedUsers.isEmpty {
                VStack(alignment: .leading) {
                    Text("Joined Users")
                        .font(.headline)
                        .padding(.top, 3)

                    ForEach(viewModel.joinedUsers) { user in
                        Text(user.name)
                            .padding(.vertical, 2)
                    }
                }
                .padding(.horizontal)
            }


            Spacer()
// TODO add start circle logic
            if viewModel.canStartCircle {
                Button(action: {
                }) {
                    Text("Start Circle")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Create Circle")
    }
}

#Preview {
    CreateCircleView()
}
