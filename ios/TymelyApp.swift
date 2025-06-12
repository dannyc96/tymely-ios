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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
