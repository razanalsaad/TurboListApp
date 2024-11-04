//
//  loggedOutView.swift
//  TurboList
//
//  Created by Rahaf ALghuraibi on 02/05/1446 AH.
//

import SwiftUI
import AuthenticationServices
import CloudKit
struct loggedOutView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
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
            
        }
           
    }
}

#Preview {
    loggedOutView()
}
