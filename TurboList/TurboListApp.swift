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
    @State private var isSplashScreenActive = true
    
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
                    .applyDynamicType() // Apply globally
            } else {
                SignInView()
                    .applyDynamicType() // Apply globally
            }
        }
    }
}


