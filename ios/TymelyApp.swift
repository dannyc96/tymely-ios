//
//  TymelyApp.swift
//  Tymely
//
//  Created by Danny Chambers on 6/12/25.
//

import SwiftUI

@main
struct TymelyApp: App {
    let persistenceController = PersistenceController.shared
    
    // Initialize notification manager
    @StateObject private var notificationManager = NotificationManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    // Request notification permissions and schedule notifications when app starts
                    notificationManager.requestNotificationPermissions()
                }
        }
    }
}
