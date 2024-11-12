import SwiftUI
import AuthenticationServices
import Combine

class UserSession: ObservableObject {
    static let shared = UserSession() // Singleton instance
    @Published var userID: String? {
        didSet {
            isUserSignedIn = userID != nil
        }
    }
    @AppStorage("isUserSignedIn") private var isUserSignedIn: Bool = false
    @AppStorage("userID") private var storedUserID: String? // Store userID

    private init() {
        // عند بدء التشغيل، تعيين userID بالقيمة المخزنة إذا كانت موجودة
        self.userID = storedUserID
    }

    func setUserID(_ id: String?) {
        self.userID = id
        self.storedUserID = id
    }

    func getUserID(completion: @escaping (Bool) -> Void) {
        if let userID = userID {
            completion(true)
            return
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let fetchedUserID = "000875.e0e241ae7b184e2cac2264ffd0d82314.0723"
            DispatchQueue.main.async {
                self.setUserID(fetchedUserID)
                completion(self.userID != nil)
            }
        }
    }

    // Logout function to clear user session
    func logout() {
        userID = nil
        storedUserID = nil
        isUserSignedIn = false
    }
}

struct SignInView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isGuest: Bool = false
    @State private var isSignedIn: Bool = false
    @EnvironmentObject var userSession: UserSession
    @AppStorage("isUserSignedIn") private var isUserSignedIn: Bool = false // Store signed-in state
        @StateObject private var viewModel: CreateListViewModel
        @StateObject private var vm: CloudKitUserBootcampViewModel
        // Initializer that accepts a UserSession
        init(userSession: UserSession) {
            _viewModel = StateObject(wrappedValue: CreateListViewModel(userSession: userSession))
            _vm = StateObject(wrappedValue: CloudKitUserBootcampViewModel(userSession: userSession))
        }
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundAppColor")
                    .ignoresSafeArea()
                
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                
                Image("Back1")
                    .ignoresSafeArea()
                    .offset(y: -140)
                
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
                                viewModel.saveUserRecord(userSession: userSession, username: vm.userName) { success in
                                    if success {
                                        print("User record saved successfully.")
                                    } else {
                                        print("Failed to save user record.")
                                    }
                                    
                                }
                           

                                
                               
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
                    
//                    Text("or")
//                        .font(.system(size: 16, weight: .bold, design: .default))
//                        .foregroundColor(Color("GreenDark"))
//                        .offset(y: -370)
//                        .accessibilityLabel("or")
//                        .accessibilityHint("Alternative sign-in method")
                    
//                    // "Continue as Guest" Navigation Link
//                    NavigationLink(destination: MainTabView().navigationBarBackButtonHidden(true), isActive: $isGuest) {
//                        Button(action: {
//                            isGuest = true
//                        }) {
//                            Text("Continue as Guest")
//                                .font(.system(size: 13, weight: .bold))
//                                .foregroundColor(Color("buttonColor"))
//                        }
//                        .accessibilityLabel("Continue as Guest")
//                        .accessibilityHint("Access the app without signing in")
//                    }
                    .padding(.bottom, 30)// edit 
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
            userSession.setUserID(userIdentifier) // Set userID permanently
            print("User ID: \(userIdentifier)")
            isUserSignedIn = true  // Set to true after successful login
            isSignedIn = true
        }
    }

    
    
}
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(userSession: UserSession.shared) // Use the singleton instance
            .environmentObject(UserSession.shared) // Inject into the environment if needed
    }
}

//#Preview {
//    SignInView()
//}
// 
