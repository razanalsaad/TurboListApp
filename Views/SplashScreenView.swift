import SwiftUI

struct SplashScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Background color with no specific accessibility information
            Color("backgroundAppColor")
                .ignoresSafeArea()

            // Background image
            Image("SplashScreenBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .accessibilityHidden(true)  // Marked as decorative so VoiceOver skips it
            
            // App Icon with a meaningful accessibility label
            Image("App_Icon")
                .resizable()
                .frame(width: 206, height: 290)
                .accessibilityLabel("TurboList App Icon")
                .accessibilityHint("Welcome to TurboList")
        }
        .accessibilityElement(children: .ignore) // Avoid treating each element individually
        .accessibilityLabel("Welcome to TurboList. The app is loading.") // Combined label for the whole screen
        .accessibilityAddTraits(.isHeader)  // Mark this view as a header for VoiceOver
    }
}

#Preview {
    SplashScreenView()
}
