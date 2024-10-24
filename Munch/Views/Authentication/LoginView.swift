import SwiftUI

struct LoginView: View {
    @State private var showingAlert = false // Added State variable

    var body: some View {
        VStack{
            Spacer()
            HStack {
                Image("MunchLogo")
                    .resizable()
                    .frame(width: 300, height: 300)
            }

            Spacer()
         
            Text("Munch, Let's Eat!")
                .font(.system(.largeTitle, design: .rounded))
                .bold()
                .multilineTextAlignment(.center)
   
            Spacer()
            Spacer()
            
            Button(action: {
                // Apple sign-in action
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
                showingAlert = true // add later
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
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Coming Soon"),
                message: Text("Google Sign-In is coming soon."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    LoginView()
}
