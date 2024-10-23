import SwiftUI

struct SplashScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
   
            Color("backgroundAppColor")
                .ignoresSafeArea()

            Image("SplashScreenBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Image("App_Icon")
                .resizable()
                .frame(width: 151, height: 164)
        }
    }
}

#Preview {
    SplashScreenView()
}
