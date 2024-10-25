import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("MunchLogo")
                .resizable()
                .frame(width: 300, height: 300)
            
            Spacer()
            
            Text("Munch, Let's Eat!")
                .font(.system(.largeTitle, design: .rounded))
                .bold()
                .multilineTextAlignment(.center)
            
            Spacer()
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: { _ in
                        viewModel.signInWithApple()
                    },
                    onCompletion: { _ in }
                )
                .frame(height: 50)
                .padding(.horizontal, 40)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.restoreUserSession()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationViewModel())
}
