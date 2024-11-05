import SwiftUI
import AuthenticationServices
import Combine

class UserSession: ObservableObject {
    @Published var userID: String? // Store user ID here
}
struct SignInView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isGuest: Bool = false
    @State private var isSignedIn: Bool = false
    @EnvironmentObject var userSession: UserSession
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundAppColor")
                    .ignoresSafeArea()

                Image("OnboardingBackground")
                    .ignoresSafeArea()
                    .offset(y: -140)
                    .accessibilityHidden(true)

                VStack {
                    Text("Sort Fast, Shop Faster.")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(Color("buttonColor"))
                        .padding(.bottom, 20)
                        .accessibilityLabel("Sort Fast, Shop Faster.")
                        .accessibilityHint("Welcome message")

                    Spacer()
                    
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
                    .frame(width: 342, height: 54)
                    .cornerRadius(14)
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

                    // "Continue as Guest" Navigation Link
                    NavigationLink(destination: MainTabView().navigationBarBackButtonHidden(true), isActive: $isGuest) {
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
                
                NavigationLink(destination: MainTabView().environmentObject(userSession).navigationBarBackButtonHidden(true), isActive: $isSignedIn) {
                    EmptyView()
                        .accessibilityHidden(true)
                }

            }
        }
    }
    
    func handleAuthorization(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User ID: \(userIdentifier)")
            if let name = fullName {
                print("User Name: \(name.givenName ?? "") \(name.familyName ?? "")")
                // Save the user ID to the shared session
                           userSession.userID = userIdentifier
                           
            }
            if let email = email {
                print("User Email: \(email)")
            }
            
            isSignedIn = true
        }
    }
}

#Preview {
    SignInView()
}
