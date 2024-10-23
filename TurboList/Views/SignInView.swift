import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isGuest: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundAppColor")
                    .ignoresSafeArea()

                Image("OnboardingBackground")
                    .ignoresSafeArea()
                    .offset(y: -140)
                
                VStack {
                    Text("Sort Fast, Shop Faster.")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(Color("buttonColor"))
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    SignInWithAppleButton(
                        onRequest: { request in

                        },
                        onCompletion: { result in

                        }
                    )
                    .frame(width: 282, height: 51)
                    .cornerRadius(50)
                    .padding(.horizontal, 80)
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    Spacer().frame(height: 390)
                    
                    Text("or")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(Color("GreenDark"))
                        .offset(y: -370)
                    
                    NavigationLink(destination: MainTabView(), isActive: $isGuest) {
                        Button(action: {
                            isGuest = true
                        }) {
                            Text("Continue as Guest")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color("buttonColor"))
                        }
                    }
                    .padding(.top, -370)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 270)
            }
        }
    }
}

#Preview {
    SignInView()
}
