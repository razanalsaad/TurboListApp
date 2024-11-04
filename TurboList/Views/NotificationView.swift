import SwiftUI
import UserNotifications

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
                                        "Remember to buy groceries every two weeks!",
                                        "Remember to buy groceries every three weeks!",
                                        "Remember to buy groceries monthly!",
                                        "Your friend shared a collaborative list."
                                    ]
                                    
                                    ForEach(notifications.indices, id: \.self) { index in
                                        NavigationLink(destination: AccountView()) {
                                            NotificationItemView(icon: "bell.badge.circle", message: notifications[index])
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        
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
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            requestNotificationPermission()
            scheduleNotification()
        }
    }

    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Grocery Reminder"
        content.body = "It's time to buy groceries!"
        content.sound = .default

        // Schedule the notification for 5 minutes from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for 5 minutes from now.")
            }
        }
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
                .font(.system(size: 12, weight: .regular)) // Adjusted font size here
                .foregroundColor(Color("buttonColor"))
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    NotificationView()
}

