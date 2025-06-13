import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    // MARK: - Permission Handling
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("✅ Notification permissions granted")
                    self.scheduleAllRoutineNotifications()
                } else {
                    print("❌ Notification permissions denied")
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // MARK: - Scheduling Notifications
    
    func scheduleAllRoutineNotifications() {
        // Remove all existing notifications first
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Schedule notifications for each routine item
        for item in SampleData.routineItems {
            scheduleNotifications(for: item)
        }
        
        print("📅 Scheduled notifications for \(SampleData.routineItems.count) routine items")
    }
    
    private func scheduleNotifications(for item: RoutineItem) {
        guard let itemTime = parseTime(from: item.time) else {
            print("⚠️ Could not parse time for item: \(item.title)")
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Create today's version of the item time
        let todayItemTime = calendar.date(bySettingHour: calendar.component(.hour, from: itemTime),
                                        minute: calendar.component(.minute, from: itemTime),
                                        second: 0,
                                        of: now) ?? itemTime
        
        // If the time has already passed today, schedule for tomorrow
        let targetDate = todayItemTime <= now ? 
            calendar.date(byAdding: .day, value: 1, to: todayItemTime) ?? todayItemTime : 
            todayItemTime
        
        // Schedule 15-minute reminder
        if let reminderTime = calendar.date(byAdding: .minute, value: -15, to: targetDate) {
            scheduleNotification(
                identifier: "\(item.id)-reminder",
                title: "🔔 Routine Reminder",
                body: "\(item.title) in 15 minutes",
                time: reminderTime,
                sound: .default
            )
        }
        
        // Schedule exact time notification
        scheduleNotification(
            identifier: "\(item.id)-exact",
            title: "⏰ \(item.title)",
            body: getNotificationBody(for: item),
            time: targetDate,
            sound: .default
        )
    }
    
    private func scheduleNotification(identifier: String, title: String, body: String, time: Date, sound: UNNotificationSound) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        content.badge = 1
        
        // Create date components for the trigger
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error.localizedDescription)")
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                print("✅ Scheduled: \(title) for \(formatter.string(from: time))")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func parseTime(from timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.date(from: timeString)
    }
    
    private func getNotificationBody(for item: RoutineItem) -> String {
        // Use the first detail as the notification body, or a default message
        if let firstDetail = item.details.first, !firstDetail.isEmpty {
            return firstDetail
        } else if let tag = item.tag {
            return "Time for your \(tag.lowercased()) routine"
        } else {
            return "It's time for this routine item"
        }
    }
    
    // MARK: - Utility Methods
    
    func sendTestNotification() {
        // First check if we have permission
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                print("🔍 Notification authorization status: \(settings.authorizationStatus.rawValue)")
                print("🔍 Alert setting: \(settings.alertSetting.rawValue)")
                print("🔍 Sound setting: \(settings.soundSetting.rawValue)")
                
                if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                    self.scheduleTestNotification()
                } else {
                    print("❌ Notifications not authorized. Status: \(settings.authorizationStatus)")
                }
            }
        }
    }
    
    private func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🧪 Test Notification"
        content.body = "This is a test notification from Tymely! Notifications are working correctly."
        content.sound = .default
        content.badge = 1
        
        // Trigger the notification in 5 seconds to give more time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "test-notification-\(Date().timeIntervalSince1970)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error sending test notification: \(error.localizedDescription)")
            } else {
                print("✅ Test notification scheduled for 5 seconds from now")
                print("💡 Make sure to put the app in the background or lock your device to see the notification!")
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("🗑️ Cancelled all pending notifications")
    }
    
    func getPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("📋 Pending notifications: \(requests.count)")
            for request in requests {
                print("  - \(request.identifier): \(request.content.title)")
            }
        }
    }
} 