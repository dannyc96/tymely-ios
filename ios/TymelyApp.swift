//
//  TymelyApp.swift
//  Tymely
//
//  Created by Danny Chambers on 6/12/25.
//

import SwiftUI
import UserNotifications

// Notification delegate to handle foreground notifications
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification even when app is in foreground
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification tap
        print("📱 Notification tapped: \(response.notification.request.content.title)")
        completionHandler()
    }
}

@main
struct TymelyApp: App {
    let persistenceController = PersistenceController.shared
    
    // Initialize notification manager and delegate
    @StateObject private var notificationManager = NotificationManager.shared
    private let notificationDelegate = NotificationDelegate()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    // Set up notification delegate
                    UNUserNotificationCenter.current().delegate = notificationDelegate
                    
                    // Request notification permissions and schedule notifications when app starts
                    notificationManager.requestNotificationPermissions()
                }
        }
    }
}
