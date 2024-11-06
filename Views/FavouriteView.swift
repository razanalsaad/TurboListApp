import SwiftUI

struct FavouriteView: View {
    @State private var isBellTapped = false
    @StateObject private var vm = CloudKitUserBootcampViewModel()
    @EnvironmentObject var userSession: UserSession
    @State private var showNotificationView = false // حالة التنقل

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
                                .stroke(Color("buttonColor"), lineWidth: 2)
                                .frame(width: 50, height: 50)

                            // Display the user's profile image or a placeholder icon if not available
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
                            showNotificationView = true // تفعيل التنقل
                        }
                        .padding(.trailing)
                    }
                    .padding(.top)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    FavouriteView()
}
