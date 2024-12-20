//
//  TurboListApp.swift
//  TurboList
//
//  Created by razan on 17/10/2024.
//
import SwiftUI

struct DynamicTypeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .dynamicTypeSize(.xSmall ... .accessibility5) // Apply dynamic type scaling
    }
}

extension View {
    func applyDynamicType() -> some View {
        self.modifier(DynamicTypeModifier()) // Use the custom modifier
    }
}

@main
struct TurboListApp: App {
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete = false
    @AppStorage("isUserSignedIn") private var isUserSignedIn = false // Check if the user is signed in
    @State private var isSplashScreenActive = true
//    @StateObject var userSession = UserSession()
    @StateObject private var viewModel = CreateListViewModel(userSession: UserSession.shared) // Use the singleton instance
    
    var body: some Scene {
        WindowGroup {
            if isSplashScreenActive {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isSplashScreenActive = false
                            }
                        }
                    }
                    .applyDynamicType()
            } else {
                if isOnboardingComplete {
                    if isUserSignedIn {
                        MainTabView()
                            .applyDynamicType()
                            .environmentObject(UserSession.shared)
                    } else {
                        SignInView(userSession: viewModel.userSession)
                            .applyDynamicType()
                            .environmentObject(UserSession.shared)
                    }
                } else {
                    OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                        .applyDynamicType()
                }
            }
        }
    }
}
