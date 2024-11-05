import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @StateObject var userSession = UserSession() // Create UserSession as a StateObject
    var body: some View {
        NavigationStack {
            ZStack {
                if selectedTab == 0 {
                    ListsView()
                        .environmentObject(userSession) // Pass UserSession to ListsView
                } else if selectedTab == 1 {
                    FavouriteView()
                        .environmentObject(userSession) // Pass UserSession to FavouriteView
                } else {
                    AccountView()
                        .environmentObject(userSession) // Pass UserSession to AccountView
                }
                
                VStack {
                    Spacer()
                    HStack(spacing: 108) {
                        
                        Button(action: {
                            selectedTab = 0
                        }) {
                            VStack(spacing: 5) {
                                Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                                    .font(.system(size: 20))
                                    .foregroundColor(selectedTab == 0 ? Color("MainColor") : Color("tabbar"))
                                Text("Lists")
                                    .font(.system(size: 11))
                                    .foregroundColor(selectedTab == 0 ? Color("MainColor") : Color("tabbar"))
                            }
                        }
                        .accessibilityLabel("Lists Tab")
                        .accessibilityHint("Double tap to view your lists")
                        .accessibilityAddTraits(selectedTab == 0 ? .isSelected : [])
                        
                        Button(action: {
                            selectedTab = 1
                        }) {
                            VStack(spacing: 5) {
                                Image(systemName: selectedTab == 1 ? "suit.heart.fill" : "suit.heart")
                                    .font(.system(size: 20))
                                    .foregroundColor(selectedTab == 1 ? Color("MainColor") : Color("tabbar"))
                                Text("Favourite")
                                    .font(.system(size: 11))
                                    .foregroundColor(selectedTab == 1 ? Color("MainColor") : Color("tabbar"))
                            }
                        }
                        .accessibilityLabel("Favourite Tab")
                        .accessibilityHint("Double tap to view your favourite items")
                        .accessibilityAddTraits(selectedTab == 1 ? .isSelected : [])
                        
                        Button(action: {
                            selectedTab = 2
                        }) {
                            VStack(spacing: 5) {
                                Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                                    .font(.system(size: 20))
                                    .foregroundColor(selectedTab == 2 ? Color("MainColor") : Color("tabbar"))
                                Text("Account")
                                    .font(.system(size: 11))
                                    .foregroundColor(selectedTab == 2 ? Color("MainColor") : Color("tabbar"))
                            }
                        }
                        .accessibilityLabel("Account Tab")
                        .accessibilityHint("Double tap to view your account details")
                        .accessibilityAddTraits(selectedTab == 2 ? .isSelected : [])
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background(Color("bakgroundTap")
                                    .cornerRadius(20, corners: [.topLeft, .topRight]))
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationBarBackButtonHidden(true) // إخفاء زر الرجوع
            
        }
    }
}

#Preview {
    MainTabView()
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// شكل مخصص لتحديد الزوايا الدائرية
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
