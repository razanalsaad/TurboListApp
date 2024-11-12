import SwiftUI
import CloudKit

struct ListView: View {
    @Environment(\.layoutDirection) var layoutDirection
    @State private var navigateToMainTab = false
    @ObservedObject private var viewModel: ListViewModel
    @State private var showShareSheet = false
    @State private var showAlert = false
    @ObservedObject var createListViewModel: CreateListViewModel  // Observe the viewModel directly
    var listName: String  // Add this to store listName directly in ListView

    @EnvironmentObject var userSession: UserSession
 

    init(categories: [GroceryCategory], listID: CKRecord.ID?, listName: String?, createListViewModel: CreateListViewModel) {
        self.viewModel = ListViewModel(categories: categories, listID: listID, listName: listName, createListViewModel: createListViewModel)
        self.listName = listName ?? "Unnamed List"  // Assign listName to the property in ListView
        self.createListViewModel = createListViewModel  // Initialize createListViewModel
    }
    
    var body: some View {
        ZStack {
            Color("backgroundAppColor").ignoresSafeArea()
            Image("Background").resizable().ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        if viewModel.isListComplete {
                              navigateToMainTab = true // إذا كانت القائمة مكتملة، يتم الرجوع مباشرةً
                          } else {
                              showAlert = true // إذا كانت القائمة غير مكتملة، يتم إظهار رسالة التأكيد
                          }
                      })  {
                        ZStack {
                            Circle()
                                .fill(Color("GreenLight"))
                                .frame(width: 40, height: 40)
                            Image(systemName: layoutDirection == .rightToLeft ? "chevron.right" : "chevron.left")
                                .resizable()
                                .frame(width: 7, height: 12)
                                .foregroundColor(Color.green)
                        }
                    }
                    Spacer()
                    Text(listName)
                        .font(.system(size: 22, weight: .bold))
                        .multilineTextAlignment(.center)
                    Spacer()
                    Menu {
                        
                        //                        Button(action: {
                        //                            // Get all items as a flat list
                        //                                    let allItems = updatedItems.flatMap { $0.items }
                        //
                        //                                    // Post a notification to navigate back to CreateListView
                        //                            // Post the notification
                        //                                NotificationCenter.default.post(
                        //                                    name: .navigateToCreateListView,
                        //                                    object: allItems, // Pass items back for editing
                        //                                    userInfo: ["listName": "Your List Name"] // Replace with the actual list name as needed
                        //                                )
                        //                        })
                        //                        {
                        //                        Label("Edit", systemImage: "pencil")
                        //                        }
                        //                        Button(action: {
                        //                        if let currentListID = viewModel.currentListID {
                        //                            let listReference = CKRecord.Reference(recordID: currentListID, action: .none)
                        //
                        //                            let sharedListId = UUID()
                        //                            let ownerReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: userSession.userID!), action: .none)  // Assuming userSession.userID is not nil
                        //
                        //                            viewModel.saveSharedListToCloudKit(sharedListId: sharedListId, ownerId: ownerReference, listId: listReference) { sharedListSuccess in
                        //                                if sharedListSuccess {
                        //                                    print("Shared list saved successfully.")
                        //                                } else {
                        //                                    print("Failed to save shared list.")
                        //                                }
                        //                            }
                        //                        } else {
                        //                            print("Error: currentListID is nil.")
                        //                        }
                        //                            viewModel.shareList()
                        //                            }) {
                        //                                Label("Share", systemImage: "square.and.arrow.up")
                        //                        }

                        Button(action: {
                            viewModel.saveToFavorites()
                        }) {
                            Label("Favorite", systemImage: "heart")
                        }
                        Button(action: {
                            viewModel.deleteListAndMoveToMain()
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color("GreenLight"))
                                .frame(width: 40, height: 40)
                            Image(systemName: "ellipsis")
                                .resizable()
                                .frame(width: 20, height: 4)
                                .foregroundColor(Color.green)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                HStack {
                    Text("Items 🛒")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("GreenC"))
                        .padding(.leading)
                    Spacer()
                }
                .padding(.top, 15)
                
                ScrollView {
                    ForEach(viewModel.categories.indices, id: \.self) { categoryIndex in
                        let category = viewModel.categories[categoryIndex]
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(viewModel.formattedCategoryName(category.name))
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(Color("GreenDark"))
                                    .padding(.horizontal, 16)
                                Spacer()
                            }
                            .padding(layoutDirection == .leftToRight ? .leading : .trailing)
                            
                            VStack(spacing: 0) {
                                ForEach(category.items.indices, id: \.self) { itemIndex in
                                    let item = category.items[itemIndex]
                                    
                                    HStack {
                                        Button(action: {
                                            viewModel.toggleItemSelection(for: categoryIndex, itemIndex: itemIndex)
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(item.isSelected ? Color("MainColor") : Color.clear)
                                                    .frame(width: 30, height: 30)
                                                    .overlay(
                                                        Circle().stroke(Color("MainColor"), lineWidth: 2)
                                                    )
                                                if item.isSelected {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        }
                                        
                                        Text(item.name)
                                            .font(.system(size: 18))
                                            .fontWeight(.medium)
                                            .strikethrough(item.isSelected, color: Color("nameColor"))
                                            .foregroundColor(Color("nameColor"))

                                        Spacer()

                                        HStack(spacing: 1) {
                                            Button(action: {
                                                viewModel.decreaseQuantity(for: categoryIndex, itemIndex: itemIndex)
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .foregroundColor(Color("gray1"))
                                                    .font(.system(size: 30))
                                            }
                                            
                                            Text("\(category.items[itemIndex].quantity)")
                                                .font(.title3)
                                                .frame(width: 30)
                                            
                                            Button(action: {
                                                viewModel.increaseQuantity(for: categoryIndex, itemIndex: itemIndex)
                                            }) {
                                                Image(systemName: "plus.circle.fill")
                                                    .foregroundColor(Color("MainColor"))
                                                    .font(.system(size: 30))
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color("bakgroundTap"))
                                    .cornerRadius(8)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 75)
                                    .padding(.horizontal)

                                    if itemIndex != category.items.count - 1 {
                                        Divider()
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            .background(Color("bakgroundTap"))
                            .cornerRadius(15)
                            .shadow(radius: 1)
                            .padding(.horizontal)
                        }
                        .padding(.top, 20)
                    }
                }

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.saveAllItems()
        }
        .sheet(isPresented: $viewModel.isSharingAvailable) {
            if let share = viewModel.share {
                CloudSharingController(share: share, container: CKContainer.default())
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Return to lists?"),
                message: Text("Are you sure you want to return to the lists page? You haven't confirmed all items yet."),
                primaryButton: .destructive(Text("Return"), action: {
                    navigateToMainTab = true
                }),
                secondaryButton: .cancel(Text("Stay"))
            )
        }
        .background(
            NavigationLink(destination: MainTabView(), isActive: $navigateToMainTab) {
                MainTabView()
            }
        )
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        // Create mock data for testing
        let groceryItems: [GroceryCategory] = [
            GroceryCategory(name: "Bakery", items: [
                GroceryItem(name: "Bread", quantity: 2),
                GroceryItem(name: "Croissant", quantity: 5)
            ]),
            GroceryCategory(name: "Fruits & Vegetables", items: [
                GroceryItem(name: "Apple", quantity: 4),
                GroceryItem(name: "Banana", quantity: 3)
            ])
        ]
        
        // Provide mock listID and listName
        let mockListID = CKRecord.ID(recordName: "mockRecordID")
        let mockListName = "Sample List"
        
        // Use the singleton instance of UserSession
        let createListViewModel = CreateListViewModel(userSession: UserSession.shared)
        
        // Pass the categories, mock listID, listName, and createListViewModel into ListView
        ListView(categories: groceryItems, listID: mockListID, listName: mockListName, createListViewModel: createListViewModel)
            .environmentObject(UserSession.shared) // Inject the singleton UserSession instance into the environment
            .environment(\.layoutDirection, .rightToLeft) // Optional RTL layout
            .previewLayout(.sizeThatFits)
    }
}
