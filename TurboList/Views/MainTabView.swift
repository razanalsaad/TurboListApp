import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                if selectedTab == 0 {
                    ListsView()
                } else if selectedTab == 1 {
                    FavouriteView()
                } else {
                    AccountView()
                }
                
                VStack {
                    Spacer()
                    HStack(spacing: 100) {
                        // Tab 1 with accessibility
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

                        // Tab 2 with accessibility
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

                        // Tab 3 with accessibility
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
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    MainTabView()
}
