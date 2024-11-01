import SwiftUI
import SDWebImageSwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isOnboardingComplete = false
    
    let onboardingData = [
        OnboardingData(gifName: "on2", title: "Sort", description: "Organize your grocery items using AI-powered categorization sorting them by category."),
        OnboardingData(gifName: "on1", title: "Collaborative", description: "Multiple users to collaborate with instant updates to shared grocery lists.")
    ]
    
    var body: some View {
        ZStack {
            if isOnboardingComplete {
                MainTabView() // Navigate to homepage
            } else {
                Color("backgroundAppColor")
                    .ignoresSafeArea()

                Image("OnboardingBackground")
                    .ignoresSafeArea()
                    .offset(y: -140)
                    .accessibilityHidden(true) // Mark as decorative for VoiceOver

                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            print("Skipped Onboarding")
                            isOnboardingComplete = true // Skip to homepage
                        }) {
                            Text("Skip")
                                .foregroundColor(Color("buttonColor"))
                                .padding()
                        }
                        .accessibilityLabel("Skip Onboarding")
                        .accessibilityHint("Skips to the main app")
                    }
                    Spacer()

                    TabView(selection: $currentPage) {
                        ForEach(0..<onboardingData.count) { index in
                            VStack(spacing: 5) {
                                AnimatedImage(name: onboardingData[index].gifName + ".gif")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 400, height: 480)
                                    .offset(y: index == 0 ? 0 : 90)
                                    .scaleEffect(1.5)
                                    .accessibilityLabel(onboardingData[index].title)
                                    .accessibilityHint(onboardingData[index].description)

                                VStack(spacing: 0) {
                                    Text(onboardingData[index].title)
                                        .font(.system(size: 28, weight: .bold, design: .default))
                                        .foregroundColor(Color("buttonColor"))
                                        .accessibilityAddTraits(.isHeader) // Treat title as a header
                                    
                                    Text(onboardingData[index].description)
                                        .font(.system(size: 13, weight: .bold, design: .default))
                                        .foregroundColor(Color("buttonColor"))
                                        .multilineTextAlignment(.center)
                                        .frame(width: 300, height: 80)
                                        .accessibilityLabel(onboardingData[index].description) // Provide detailed description
                                }
                                .offset(y: -170)

                                HStack(spacing: 4) {
                                    ForEach(0..<onboardingData.count) { dotIndex in
                                        Circle()
                                            .frame(width: 8, height: 8)
                                            .foregroundColor(currentPage == dotIndex ? Color("MainColor") : Color("gray1"))
                                            .accessibilityHidden(true) // Hide pagination dots from VoiceOver
                                    }
                                }.offset(y: -160)
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .onAppear {
                        UIPageControl.appearance().isHidden = true
                    }
                }
                
                VStack {
                    Button(action: {
                        if currentPage == onboardingData.count - 1 {
                            print("Onboarding Completed")
                            isOnboardingComplete = true // Navigate to homepage
                        } else {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                    }) {
                        Text(currentPage == onboardingData.count - 1 ? "Get Started" : "Next")
                            .frame(width: 149, height: 37)
                            .background(Color("MainColor"))
                            .foregroundColor(.white)
                            .cornerRadius(18.5)
                    }
                    .accessibilityLabel(currentPage == onboardingData.count - 1 ? "Get Started" : "Next Step")
                    .accessibilityHint(currentPage == onboardingData.count - 1 ? "Finish onboarding and go to main app" : "Move to the next onboarding screen")
                }
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 250)
            }
        }
        .accessibilityElement(children: .combine) // Combine all elements into a single logical group
    }
}

struct OnboardingData {
    let gifName: String
    let title: String
    let description: String
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
