//import SwiftUI
//
//struct MaiTabView: View {
//    @State private var selectedTab: Int = 0
//    let tabBarItems = [
//        ("house", "الرئيسية"),
//        ("heart", "المفضلة")
//    ]
//    
//    var body: some View {
//        VStack {
//            Spacer()
//            
//            // هنا يتم عرض المحتوى بناءً على التبويب المحدد
//            if selectedTab == 0 {
//                Text("العلامة التبويب الأولى")
//            } else if selectedTab == 1 {
//                Text("العلامة التبويب الثانية")
//            }
//            
//            Spacer()
//            
//            CustomTabBar(selectedTab: $selectedTab, tabBarItems: tabBarItems)
//        }
//        .edgesIgnoringSafeArea(.bottom)
//    }
//}
//
//struct CustomTabBar: View {
//    @Binding var selectedTab: Int
//    let tabBarItems: [(icon: String, title: String)]
//    
//    var body: some View {
//        HStack {
//            ForEach(0..<tabBarItems.count, id: \.self) { index in
//                Button(action: {
//                    selectedTab = index
//                }) {
//                    VStack {
//                        Image(systemName: tabBarItems[index].icon)
//                            .symbolVariant(selectedTab == index ? .fill : .none)
//                            .font(.system(size: 24))
//                            .foregroundColor(selectedTab == index ? Color.blue : Color.gray)
//                        
//                        Text(tabBarItems[index].title)
//                            .font(.caption)
//                            .foregroundColor(selectedTab == index ? Color.blue : Color.gray)
//                    }
//                }
//                .frame(maxWidth: .infinity) // توزيع الأزرار بشكل متساوٍ
//            }
//        }
//        .padding(.vertical, 10)
//        .background(Color.white.shadow(radius: 2))
//    }
//}
//
//struct ContentView: View {
//    var body: some View {
//        MaiTabView()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
