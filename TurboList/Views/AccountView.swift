import SwiftUI
import AuthenticationServices

struct AccountView: View {
    @State private var username: String = "Ahad"
    @State private var isEditing: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @State private var isDarkMode: Bool = false
    @State private var isLoggedIn: Bool = true
    @State private var navigateToNotification: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundAppColor")
                    .ignoresSafeArea()

                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 85)

                    ZStack {
                        Circle()
                            .stroke(Color("GreenLight"), lineWidth: 4)
                            .frame(width: 120, height: 120)
                        
                        if isLoggedIn {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color("buttonColor"))
                        } else {
                            Image(systemName: "person.fill.questionmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color("buttonColor"))
                        }
                    }
                    
                    if isLoggedIn {
                        loggedInView
                    } else {
                        loggedOutView
                    }
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $navigateToNotification) {
                NotificationView()  
            }
        }
    }
    
    var loggedInView: some View {
        VStack(spacing: 8) {
            HStack {
                Text(username)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("GreenDark"))
                    .padding(.leading, 25)
                
                Button(action: {
                    isEditing.toggle()
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(Color("MainColor"))
                }
            }
            
            Text("@RealAhad")
                .foregroundColor(Color.gray)
                .font(.subheadline)
            
            Spacer().frame(height: 40)
            
            VStack(spacing: 0) {
                SettingRow(icon: "globe", title: "Language", iconColor: Color("MainColor"), textColor: Color("GreenDark")) {
                    openAppSettings()
                }
                Divider()
                
                SettingRow(icon: "bell", title: "Notification", iconColor: Color("MainColor"), textColor: Color("GreenDark")) {
                    navigateToNotification = true // تنشيط التنقل إلى NotificationView
                }
                Divider()
                
                SettingRow(icon: colorScheme == .dark ? "sun.max" : "moon",
                           title: colorScheme == .dark ? "Light Mode" : "Dark Mode",
                           iconColor: Color("MainColor"), textColor: Color("GreenDark")) {
                    isDarkMode.toggle()
                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                }
                Divider()
                
                SettingRow(icon: "rectangle.portrait.and.arrow.right", title: "Log out", iconColor: Color("red22"), textColor: Color("red22")) {
                    logoutUser()
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    var loggedOutView: some View {
        VStack(spacing: 8) {
            Text("You do not have an account yet")
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(Color("GreenDark"))
                .padding(.top, 40)
            
            Text("Create new account now")
                .foregroundColor(Color("buttonColor"))
                .fontWeight(.bold)
                .font(.subheadline)
                .padding(.top, 20)
            
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
            .padding(.top, 20)
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .accessibilityLabel("Sign in with Apple")
            .accessibilityHint("Use your Apple ID to sign in")
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
            }
            if let email = email {
                print("User Email: \(email)")
            }
            
            isLoggedIn = true
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }
    }
    
    func logoutUser() {
        print("Logging out...")
        isLoggedIn = false
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }

    func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
}

struct SettingRow: View {
    var icon: String
    var title: String
    var iconColor: Color = .black
    var textColor: Color = .black
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .foregroundColor(textColor)
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    AccountView()
}
