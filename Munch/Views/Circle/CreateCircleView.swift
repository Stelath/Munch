//
//  CreateCircleView.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import SwiftUI
import CoreLocationUI


struct CreateCircleView: View {
    @StateObject private var viewModel = CreateCircleViewModel()
    
    var body: some View {
        VStack {
            Text("Create a Circle")
                .font(.largeTitle)
                .padding()

            TextField("Name", text: $viewModel.name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                //TODO: How many restaurants to pick from and pick a new location - mac
            ZStack {
                        TextField("Location", text: $viewModel.location)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.fillCurrentCity()
                            }) {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.blue)
                            }
                            .padding(.trailing, 25)
                        }
                    }
    
            
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
            
            if let code = viewModel.generatedCode {
                ZStack {
                    Text("Circle Code: \(code)")
                        .font(.title2)
                        .fontWeight(.bold)
                    HStack {
                        Spacer()
                        ShareLink(
                            item: "Join my circle on Munch! Use this code: \(code)",
                            subject: Text("Join My Munch Circle"),
                            message: Text("Use this code to join my circle on Munch: \(code)"),
                            preview: SharePreview("Join My Munch Circle", image: Image(systemName: "circle.fill"))
                        ) {
                            Image(systemName: "square.and.arrow.up")
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                                .padding(8)
                                .accessibilityLabel("Share Circle Code")
                        }
                    }
                    .padding(.trailing, 25)
                }
                .padding(.horizontal)
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
            if !viewModel.joinedUsers.isEmpty {
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
