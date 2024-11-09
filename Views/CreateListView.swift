import SwiftUI
import Combine
import UserNotifications
import CloudKit

struct CreateListView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.layoutDirection) var layoutDirection
    @StateObject private var viewModel: CreateListViewModel
    @EnvironmentObject var userSession: UserSession
    @State private var newListName: String = ""
    @State private var isCreatingNewList = false

    // Initializer that accepts a UserSession
    init(userSession: UserSession) {
        _viewModel = StateObject(wrappedValue: CreateListViewModel(userSession: userSession))
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundAppColor")
                    .ignoresSafeArea()
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    // Your existing UI code...
                    HStack {
                        Button(action: { dismiss() }) {
                            ZStack {
                                Circle()
                                    .fill(viewModel.isBellTapped ? Color("MainColor") : Color("GreenLight"))
                                    .frame(width: 40, height: 40)
                                Image(systemName: layoutDirection == .rightToLeft ? "chevron.right" : "chevron.left")
                                    .resizable()
                                    .frame(width: 7, height: 12)
                                    .foregroundColor(viewModel.isBellTapped ? .white : Color("MainColor"))
                            }
                        }

                        Spacer()

                        TextField("Enter list name", text: $viewModel.listName)
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        Spacer()

                        NavigationLink(
                            destination: ListView(
                                categories: viewModel.categorizedProducts,
                                listID: viewModel.currentListID, // Pass the actual list ID
                                listName: viewModel.listName,    // Pass the actual list name
                                createListViewModel: viewModel   // Pass viewModel as createListViewModel
                            ),
                            isActive: $viewModel.showResults
                        ) {
                            Button(action:{
                                viewModel.saveListToCloudKit(userSession: viewModel.userSession,  listName: viewModel.listName) { listID in
                                    guard let listID = listID else { return }
                             
                                    // Create a reference for the saved list
                                    let listReference = CKRecord.Reference(recordID: listID, action: .deleteSelf)

                                    // Parse items from the user input
                                    viewModel.classifyProducts() // Assuming this processes the input into categorizedProducts

                                    // Save each item using the list reference
                                    for category in viewModel.categorizedProducts {
                                        for item in category.items {
                                            viewModel.saveItem(
                                                name: item.name,
                                                quantity: Int64(item.quantity),
                                                listId: listReference,
                                                category: category.name
                                            ) { success in
                                                if success {
                                                    print("Item '\(item.name)' saved successfully in CreateListViewModel.")
                                                } else {
                                                    print("Failed to save item '\(item.name)'.")
                                                }
                                            }
                                        }
                                    }
                               
                                    viewModel.showResults = true
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(viewModel.isBellTapped ? Color("MainColor") : Color("GreenLight"))
                                        .frame(width: 40, height: 40)
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .frame(width: 17, height: 18)
                                        .foregroundColor(viewModel.isBellTapped ? .white : Color("MainColor"))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)

                    HStack {
                        Text("Items 🛒")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("GreenC"))
                        
                        Spacer()
                        
                        Menu {
                            Button("Every Week", action: { print("Selected: Every Week") })
                            Button("Every Two Weeks", action: { print("Selected: Every Two Weeks") })
                            Button("Every Three Weeks", action: { print("Selected: Every Three Weeks") })
                            Button("Every Month", action: { print("Selected: Every Month") })
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(viewModel.isBellTapped ? Color("MainColor") : Color("GreenLight"))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "calendar.badge.clock")
                                    .resizable()
                                    .frame(width: 30, height: 25)
                                    .foregroundColor(viewModel.isBellTapped ? .white : Color("MainColor"))
                                    .padding(.trailing, -5)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    ScrollView {
                        CustomTextField(text: $viewModel.userInput, placeholder: NSLocalizedString("write_down_your_list", comment: "Prompt for the user to write their list"))
                            .frame(width: 350, height: 650)
                            .cornerRadius(11.5)
                    }
                    .ignoresSafeArea(.keyboard)
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onReceive(NotificationCenter.default.publisher(for: .navigateToCreateListView)) { notification in
            if let items = notification.object as? [GroceryItem], let listName = notification.userInfo?["listName"] as? String {
                // Update the view model with previous data
                viewModel.listName = listName
                viewModel.userInput = items.map { "\($0.quantity) x \($0.name)" }.joined(separator: ", ")
                
                // Trigger navigation to show the view with the updated data
                viewModel.showResults = false // Ensure it goes back to CreateListView if needed
            }
        }


    }
    
}

extension Notification.Name {
    static let navigateToCreateListView = Notification.Name("navigateToCreateListView")
}

struct CreateListView_Previews: PreviewProvider {
    static var previews: some View {
        CreateListView(userSession: UserSession.shared) // Use the singleton instance
            .environmentObject(UserSession.shared) // Inject UserSession into the environment if needed
    }
}
