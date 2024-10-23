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

            FavouriteView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "suit.heart.fill" : "suit.heart")
                    Text("Favourite")
                }
                .tag(1)

            AccountView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                    Text("Account")
                }
                .tag(2)
        }
        .accentColor(Color("MainColor"))
        .navigationBarBackButtonHidden(true) 
    }
}

#Preview {
    MainTabView()
}
//
