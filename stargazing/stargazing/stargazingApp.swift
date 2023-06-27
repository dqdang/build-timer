//
//  stargazingApp.swift
//  stargazing
//
//  Created by Derek Dang on 6/27/23.
//

import SwiftUI

@main
struct stargazing: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
