import SwiftUI

struct ListsView: View {
    @State private var isBellTapped = false
    @State private var searchText = ""
    @State private var lists: [String] = []
    @StateObject private var vm = CloudKitUserBootcampViewModel()
    @Environment(\.layoutDirection) var layoutDirection // Get the current layout direction
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundAppColor")
                    .ignoresSafeArea()

                Image("Background")
                    .resizable()
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        ZStack {
                            Circle()
                                .stroke(Color("GreenLight"), lineWidth: 2)
                                .frame(width: 50, height: 50)

                            if let profileImage = vm.profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else {
                                ZStack {
                                    Circle()
                                        .stroke(Color("GreenLight"), lineWidth: 4)
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color("buttonColor"))
                                }
                            }
                        }
                        .padding(.leading)
                        
                        VStack(alignment: .leading) {
                            Text("Welcome")
                                .font(.subheadline)
                                .foregroundColor(Color("buttonColor"))
                            
                            Text("\(vm.userName)")
                                .font(.title2)
                                .foregroundColor(Color("GreenDark"))
                                .fontWeight(.bold)
                        }
                        
                        Spacer()

                        // Bell button for notifications
                        Button(action: {
                            isBellTapped.toggle()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(isBellTapped ? Color("MainColor") : Color("GreenLight"))
                                    .frame(width: 40, height: 40)

                                Image(systemName: "bell")
                                    .resizable()
                                    .frame(width: 18, height: 22)
                                    .foregroundColor(isBellTapped ? .white : Color("MainColor"))
                            }
                        }
                        .padding(.trailing)
                    }
                    .padding(.top)

                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color("MainColor"))
                            .padding(.leading, 8)

                        TextField("Search lists", text: $searchText)
                            .padding(.vertical, 12)
                    }
                    .background(Color("bakgroundTap"))
                    .cornerRadius(90)
                    .overlay(
                        RoundedRectangle(cornerRadius: 90)
                            .stroke(Color("strokeColor").opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .padding(.vertical)

                    HStack {
                        NavigationLink(destination: CreateListView()) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundColor(Color("MainColor"))
                        }
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical)

                    Spacer()

                    if lists.isEmpty {
                        emptyStateView
                    } else {
                        listView
                    }

                    Spacer()
                }
                .safeAreaInset(edge: .bottom) {
                    Spacer()
                        .frame(height: -90)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    var emptyStateView: some View {
        VStack {
            Image("arrow")
                .resizable()
                .frame(width: 250, height: 170)
                .foregroundColor(.green)
                .rotationEffect(layoutDirection == .rightToLeft ? .degrees(-7) : .degrees(7))
                .scaleEffect(x: layoutDirection == .rightToLeft ? -1 : 1, y: 1)
                .padding(layoutDirection == .rightToLeft ? .trailing : .leading, -10)
                .offset(x: layoutDirection == .rightToLeft ? 10 : -10, y: -20)


            Text("Create first list")
                .foregroundColor(Color("buttonColor"))
                .fontWeight(.medium)
                .padding(.leading)
                .offset(y: 2)
        }
    }

    var listView: some View {
        ScrollView {
            VStack {
                ForEach(lists, id: \.self) { list in
                    GroceryListView()
                        .padding(.bottom, 10)
                }
            }
            .padding(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ListsView()
}
