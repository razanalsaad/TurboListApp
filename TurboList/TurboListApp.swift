//
//  TurboListApp.swift
//  TurboList
//
//  Created by razan on 17/10/2024.
//

import SwiftUI

@main
struct TurboListApp: App {
    @State private var isSplashScreenActive = true
    
    var body: some Scene {
        WindowGroup {
            if isSplashScreenActive {
                SplashScreenView()
                    .onAppear {
                        // وقت عرض شاشة البداية (مثلاً 3 ثوانٍ)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isSplashScreenActive = false
                            }
                        }
                    }
            } else {
                SignInView() // هذه هي الشاشة الرئيسية التي سيتم عرضها بعد انتهاء الشاشة الأولية
            }
        }
    }
}
