import SwiftUI

struct NotificationView: View {
    @State private var isBellTapped = false
    @Environment(\.dismiss) var dismiss

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
                        Button(action: {
                            dismiss()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color("GreenLight"))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 7, height: 12)
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                        
                        Text("Notification")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color("GreenDark"))

                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)

                    Spacer()
                    
                    Rectangle()
                        .fill(Color("bakgroundTap"))
                        .cornerRadius(11, corners: [.topLeft, .topRight])
                        .overlay(
                            RoundedRectangle(cornerRadius: 11)
                                .stroke(Color("strokeColor"), lineWidth: 2)
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .ignoresSafeArea(edges: .bottom)
                        .overlay(
                            ScrollView {
                                VStack(spacing: 15) {
                                    let notifications = [
                                        "Remember to buy the weekly grocery!",
                                        "Remember to buy the weekly grocery!"
                                    ]
                                    
                                    ForEach(notifications.indices, id: \.self) { index in
                                        // Replace NavigationLink with HStack
                                        HStack {
                                            NotificationItemView(icon: "bell.badge.circle", message: notifications[index])
                                        }
                                        
                                        if index < notifications.count - 1 {
                                            Divider()
                                                .frame(maxWidth: .infinity)
                                                .background(Color("strokeColor"))
                                                .padding(.horizontal, 20)
                                        }
                                    }
                                }
                                .padding()
                            }
                        )
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct NotificationItemView: View {
    var icon: String
    var message: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(Color("GreenDark"))
            Text(message)
                .font(.system(size: 14).bold())
                .foregroundColor(Color("buttonColor"))
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    NotificationView()
}
