import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.tabbar
        UITabBar.appearance().backgroundColor = UIColor.bakgroundTap
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ListsView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Lists")
                }
                .tag(0)
                .accessibilityLabel("Lists Tab")
                .accessibilityHint("Double tap to view your lists")
                .accessibilityAddTraits(selectedTab == 0 ? .isSelected : [])  // Adds "selected" trait when active

            FavouriteView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "suit.heart.fill" : "suit.heart")
                    Text("Favourite")
                }
                .tag(1)
                .accessibilityLabel("Favourite Tab")
                .accessibilityHint("Double tap to view your favourite items")
                .accessibilityAddTraits(selectedTab == 1 ? .isSelected : [])

            AccountView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                    Text("Account")
                }
                .tag(2)
                .accessibilityLabel("Account Tab")
                .accessibilityHint("Double tap to view your account details")
                .accessibilityAddTraits(selectedTab == 2 ? .isSelected : [])
        }
        .accentColor(Color("MainColor"))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainTabView()
}

//
