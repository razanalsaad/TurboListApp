import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isGuest: Bool = false
    @State private var isSignedIn: Bool = false  // State to handle navigation after sign-in
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundAppColor")
                    .ignoresSafeArea()

                Image("OnboardingBackground")
                    .ignoresSafeArea()
                    .offset(y: -140)
                    .accessibilityHidden(true) // Decorative image

                VStack {
                    Text("Sort Fast, Shop Faster.")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(Color("buttonColor"))
                        .padding(.bottom, 20)
                        .accessibilityLabel("Sort Fast, Shop Faster.")
                        .accessibilityHint("Welcome message")

                    Spacer()
                    
                    // Sign in with Apple button
                    SignInWithAppleButton(
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authorization):
                                handleAuthorization(authorization)
                            case .failure(let error):
                                print("Sign in with Apple failed: \(error.localizedDescription)")
                            }
                        }
                    )
                    .frame(width: 282, height: 51)
                    .cornerRadius(50)
                    .padding(.horizontal, 80)
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    .accessibilityLabel("Sign in with Apple")
                    .accessibilityHint("Use your Apple ID to sign in")

                    Spacer().frame(height: 390)
                    
                    Text("or")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(Color("GreenDark"))
                        .offset(y: -370)
                        .accessibilityLabel("or")
                        .accessibilityHint("Alternative sign-in method")

                    // Continue as guest button
                    NavigationLink(destination: MainTabView(), isActive: $isGuest) {
                        Button(action: {
                            isGuest = true
                        }) {
                            Text("Continue as Guest")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color("buttonColor"))
                        }
                        .accessibilityLabel("Continue as Guest")
                        .accessibilityHint("Access the app without signing in")
                    }
                    .padding(.top, -370)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 270)
                
                // Navigation to MainTabView after successful sign-in
                NavigationLink(destination: MainTabView(), isActive: $isSignedIn) {
                    EmptyView()
                        .accessibilityHidden(true) // Hidden from accessibility
                }
            }
        }
    }
    
    // Function to handle successful Apple ID authorization
    func handleAuthorization(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // Example: Saving user data or authenticating in your app
            print("User ID: \(userIdentifier)")
            if let name = fullName {
                print("User Name: \(name.givenName ?? "") \(name.familyName ?? "")")
            }
            if let email = email {
                print("User Email: \(email)")
            }
            
            // Set the isSignedIn flag to true to trigger navigation to MainTabView
            isSignedIn = true
        }
    }
}

#Preview {
    SignInView()
}


