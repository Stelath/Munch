//
//  CreateCircleView.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

// place holder for this for now

import SwiftUI

struct CreateCircleView: View {
    @StateObject private var viewModel = CreateCircleViewModel()
    // Assume you have a way to obtain the current user's UUID
    let userId: UUID = UUID() // Replace with actual user ID retrieval - May hash it from the username they pick for now
    
    var body: some View {
        VStack {
            Text("Create a Circle")
                .font(.largeTitle)
                .padding()

            TextField("Name", text: $viewModel.name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.words)
                //TODO: How many restaurants to pick from and pick a new location - mac
            TextField("Location", text: $viewModel.location)
                       .padding()
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .autocapitalization(.words)

                   Button(action: {
                       viewModel.createCircle(userId: userId)
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

            if let code = viewModel.generatedCode {
                VStack {
                    Text("Circle Code: \(code)")
                        .font(.title2)
                        .padding()

                    Text("Share this code with your friends!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            }

            if !viewModel.joinedUsers.isEmpty {
                VStack(alignment: .leading) {
                    Text("Joined Users")
                        .font(.headline)
                        .padding(.top)

                    ForEach(viewModel.joinedUsers) { user in
                        Text(user.name)
                            .padding(.vertical, 2)
                    }
                }
                .padding(.horizontal)
            }


            Spacer()

            if viewModel.canStartCircle {
                Button(action: {
                    viewModel.startCircle()
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
        }
        .padding()
        .navigationTitle("Create Circle")
    }
}

#Preview {
    CreateCircleView()
}
