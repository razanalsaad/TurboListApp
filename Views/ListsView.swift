import SwiftUI
import Combine
import CloudKit
struct ListsView: View {
//    @StateObject private var vm = CloudKitUserBootcampViewModel()
    @StateObject private var vm: CloudKitUserBootcampViewModel
    @StateObject private var viewModel: CreateListViewModel
    @State private var searchText = ""
    @State private var isBellTapped = false
    @State private var selectedList: List?
    @State private var isNavigatingToList = false

    @State private var showNotificationView = false

    // Initialize `isHeartSelected` to match `sharedLists` count
       @State private var isHeartSelected: [Bool] = []

    @Environment(\.layoutDirection) var layoutDirection
    @EnvironmentObject var userSession: UserSession

    init() {
        // Use the shared instance of UserSession since it's a singleton
               let userSession = UserSession.shared
        _vm = StateObject(wrappedValue: CloudKitUserBootcampViewModel(userSession: userSession))

        _viewModel = StateObject(wrappedValue: CreateListViewModel(userSession: userSession))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundAppColor")
                    .ignoresSafeArea()

                Image("Background")
                    .resizable()
                    .ignoresSafeArea()

                VStack {
                    headerView
                    searchView
                    addButtonView
                    Spacer()
                    if viewModel.lists.isEmpty {
                        emptyStateView
                    } else {
                        listView
                    }
                    Spacer()
                }
                .safeAreaInset(edge: .bottom) {
                    Spacer().frame(height: -90)
                }
            }
        }
        .onAppear {
            viewModel.fetchLists { success in
                if success {
                    print("Lists fetched successfully. Total lists: \(viewModel.lists.count)")
                    // Initialize heart selection array to match the fetched lists
                    isHeartSelected = Array(repeating: false, count: viewModel.lists.count)
                } else {
                    print("Failed to fetch lists.")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var headerView: some View {
        HStack {
            profileImageView
            userGreetingView
            Spacer()
            bellButton
        }
        .padding(.top)
    }
    
    var searchView: some View {
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
    }
    
    var addButtonView: some View {
        HStack {
            NavigationLink(destination: CreateListView(userSession: viewModel.userSession)) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(Color("MainColor"))
            }
            .padding(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical)
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
            VStack(spacing: 10) {
                ForEach(viewModel.lists, id: \.listId) { list in
                    Button(action: {
                        selectedList = list
                        isNavigatingToList = true
                        viewModel.fetchItems(for: list.recordID!) { success in
                            if success {
                                print("Items fetched for list: \(list.listName)")
                            }
                        }
                    }) {
                        GroceryListView(
                            listName: list.listName,
                            isHeartSelected: bindingForHeartSelected(at: viewModel.lists.firstIndex(where: { $0.listId == list.listId }) ?? 0),
                            onCardTapped: {
                                selectedList = list
                                isNavigatingToList = true
                                viewModel.fetchItems(for: list.recordID!) { success in
                                    if success {
                                        print("Items fetched for list: \(list.listName)")
                                    }
                                }
                            }
                        )
                        .padding(.horizontal)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .background(
            NavigationLink(
                destination: ListView(
                    categories: viewModel.categorizedProducts,  // Pass fetched categories here
                    listID: selectedList?.recordID,
                    listName: selectedList?.listName,
                    createListViewModel: viewModel
                ),
                isActive: $isNavigatingToList
            ) { EmptyView() }
        )
    }



    private func bindingForHeartSelected(at index: Int) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                guard index < isHeartSelected.count else { return false }
                return isHeartSelected[index]
            },
            set: { newValue in
                if index < isHeartSelected.count {
                    isHeartSelected[index] = newValue
                }
            }
        )
    }


    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
                return
            }

            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    // Additional views for the header elements
    var profileImageView: some View {
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
    }
    
    var userGreetingView: some View {
        VStack(alignment: .leading) {
            Text("Welcome")
                .font(.subheadline)
                .foregroundColor(Color("buttonColor"))
            Text("\(vm.userName)")
                .font(.title2)
                .foregroundColor(Color("GreenDark"))
                .fontWeight(.bold)
        }
    }
    
    var bellButton: some View {
        NavigationLink(destination: NotificationView(), isActive: $showNotificationView) {
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
        .onTapGesture {
            showNotificationView = true
        }
        .padding(.trailing)
    }
}
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


struct ListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListsView()
            .environmentObject(UserSession.shared) // Use the singleton instance directly
    }
}
