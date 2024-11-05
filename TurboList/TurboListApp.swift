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
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete = false // تخزين حالة الأونبوردنق
    @State private var isSplashScreenActive = true // حالة التحكم بظهور شاشة السبلاش

    var body: some Scene {
        WindowGroup {
            if isSplashScreenActive {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isSplashScreenActive = false // إنهاء عرض شاشة السبلاش بعد 3 ثوانٍ
                            }
                        }
                    }
                    .applyDynamicType() // تطبيق حجم النص الديناميكي على شاشة السبلاش
            } else {
                if isOnboardingComplete {
                    SignInView() // الانتقال إلى شاشة تسجيل الدخول إذا كان الأونبوردنق مكتملًا
                        .applyDynamicType() // تطبيق حجم النص الديناميكي على شاشة تسجيل الدخول
                } else {
                    OnboardingView(isOnboardingComplete: $isOnboardingComplete) // عرض شاشة الأونبوردنق
                        .applyDynamicType() // تطبيق حجم النص الديناميكي على شاشة الأونبوردنق
                }
            }
        }
    }
}



