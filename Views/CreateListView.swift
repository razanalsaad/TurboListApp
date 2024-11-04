import SwiftUI

struct CreateListView: View {
    @StateObject private var viewModel = CreateListViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundAppColor")
                    .ignoresSafeArea()
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            ZStack {
                                Circle()
                                    .fill(viewModel.isBellTapped ? Color("MainColor") : Color("GreenLight"))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "chevron.left")
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

                        NavigationLink(destination: ListView(categories: viewModel.categorizedProducts), isActive: $viewModel.showResults) {
                            Button(action: {
                                viewModel.classifyProducts()
                                viewModel.showResults = true
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
                                    .fill(viewModel.isBellTapped ? Color("MainColor") : Color("GreenLight"))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "calendar.badge.clock")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(viewModel.isBellTapped ? .white : Color("MainColor"))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    ScrollView {  // وضع TextEditor داخل ScrollView
                        CustomTextField(text: $viewModel.userInput, placeholder: "write down your list")
                            .frame(width: 350, height: 590)
                            .cornerRadius(11.5)
//                            .shadow(radius: 1)
                    }
                    .ignoresSafeArea(.keyboard) // لمنع تحرك TextEditor عند ظهور لوحة المفاتيح
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                          ToolbarItem(placement: .navigationBarLeading) {
                              EmptyView() // إخفاء زر الرجوع الافتراضي
                          }
        }
    }
}
struct CreateListView_Previews: PreviewProvider {
    static var previews: some View {
        CreateListView()
            .environmentObject(CreateListViewModel())
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
    }
    }
}
