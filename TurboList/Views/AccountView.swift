import SwiftUI

struct AccountView: View {
    @State private var username: String = "Ahad"
    @State private var isEditing: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @State private var isDarkMode: Bool = false  
    var body: some View {
        ZStack {
            Color("backgroundAppColor")
                .ignoresSafeArea()

            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {

                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .stroke(Color("GreenLight"), lineWidth: 4)
                            .frame(width: 120, height: 120)

                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("GreenDark"))
                    }
                    

                    HStack {
                        Text(username)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("GreenDark"))
                            .padding(.leading, 25)
                        
                        Button(action: {
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(Color("MainColor"))
                        }
                    }
                    
                    Text("@RealAhad")
                        .foregroundColor(Color.gray)
                        .font(.subheadline)
                }
                .padding(.top, 40)
                
                Spacer().frame(height: 40)
                
                VStack(spacing: 0) {
                    SettingRow(icon: "globe", title: "Language", iconColor: Color("MainColor"), textColor: Color("GreenDark")) {
                        print("Language tapped")
                    }
                    Divider()
                    
                    SettingRow(icon: "bell", title: "Notification", iconColor: Color("MainColor"), textColor: Color("GreenDark")) {
                        print("Notification tapped")
                    }
                    Divider()
                    
                    SettingRow(icon: colorScheme == .dark ? "sun.max" : "moon",
                               title: colorScheme == .dark ? "Light Mode" : "Dark Mode",
                               iconColor: Color("MainColor"), textColor: Color("GreenDark")) {
                        isDarkMode.toggle()
                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                    }
                    Divider()
                    
                    SettingRow(icon: "rectangle.portrait.and.arrow.right", title: "Log out", iconColor:Color("red"), textColor: Color("red")) {
                        // Action for Log out
                        print("Log out tapped")
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
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
