import SwiftUI

struct CreateListView: View {
    
    @State private var isBellTapped: Bool = false
    @State private var listName: String = ""
    @State private var userInput: String = ""
    @State private var notificationFrequency: String = "Select Frequency"
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color("backgroundAppColor")
                .ignoresSafeArea()
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(isBellTapped ? Color("MainColor") : Color("GreenLight"))
                                .frame(width: 40, height: 40)
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 7, height: 12)
                                .foregroundColor(isBellTapped ? .white : Color("MainColor"))
                        }
                    }

                    Spacer()

                    TextField("Enter list name", text: $listName)
                        .font(.system(size: 20, weight: .bold))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Spacer()

                    Button(action: {
                        saveList()
                    }) {
                        ZStack {
                            Circle()
                                .fill(isBellTapped ? Color("MainColor") : Color("GreenLight"))
                                .frame(width: 40, height: 40)
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 17, height: 18)
                                .foregroundColor(isBellTapped ? .white : Color("MainColor"))
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)

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
                                .fill(isBellTapped ? Color("MainColor") : Color("GreenLight"))
                                .frame(width: 40, height: 40)
                            Image(systemName: "calendar.badge.clock")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(isBellTapped ? .white : Color("MainColor"))
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)

                CustomTextField(text: $userInput, placeholder: "write down your list")
                    .frame(width: 350, height: 590)
                    .cornerRadius(11.5)
                    .shadow(radius: 1)
                    .frame(minHeight: 200, maxHeight: .infinity)
                    .padding(.top, -30)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func saveList() {
        print("Saving the list: \(listName) with frequency: \(notificationFrequency)")
    }
}

#Preview {
    CreateListView()
}
