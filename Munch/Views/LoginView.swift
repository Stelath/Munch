//
//  LoginView.swift
//  Munch
//
//  Created by John Severson on 6/28/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack{
            HStack {
                Image("MunchNoBack")
                    .resizable()
                    .frame(width: 50, height: 51)
                Text("Munch")
                    .font(.system(size: 40, design: .rounded))
                    .bold()
            }
            
            Spacer()
         
            Text("Not sure where to eat, swipe to find a place to Munch")
                .font(.system(.title, design: .rounded))
                .bold()
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 10, leading: 35, bottom: 10, trailing: 35))
   
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                HStack {
                    Image("apple-logo")
                        .resizable()
                        .frame(width:25, height: 25)
                        .colorInvert()
                    Text("Sign in with Apple")
                        .foregroundColor(.white)
                        .font(.system(.title2, design: .rounded))
                        .bold()
                }
                .padding(EdgeInsets(top: 16, leading: 38, bottom: 16, trailing: 38))
            })
            .background(.black)
            .cornerRadius(40)
            
            Button(action: {
                
            }, label: {
                HStack {
                    Image("Google-logo")
                        .resizable()
                        .frame(width:25, height: 25)
                    Text("Sign in with Google")
                        .foregroundColor(.white)
                        .font(.system(.title2, design: .rounded))
                        .bold()
                }
                .padding(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
            })
            .background(.black)
            .cornerRadius(40)
            .padding()
            
        }
    }
}

#Preview {
    LoginView()
}
