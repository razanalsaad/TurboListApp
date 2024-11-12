//
//  NotificationViewModel.swift
//  TurboList
//
//  Created by Faizah Almalki on 10/05/1446 AH.
//

import Foundation
import SwiftUI
import Combine

class NotificationViewModel: ObservableObject {
    @Published var notifications: [String] = []
    
    init() {
        loadNotifications()
    }
    
    func addNotification(_ message: String) {
        notifications.append(message)
        saveNotifications()
    }
    
    private func loadNotifications() {
        if let savedNotifications = UserDefaults.standard.array(forKey: "savedNotifications") as? [String] {
            notifications = savedNotifications
        }
    }
    
    private func saveNotifications() {
        UserDefaults.standard.set(notifications, forKey: "savedNotifications")
    }
}
