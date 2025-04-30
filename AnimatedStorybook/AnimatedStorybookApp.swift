//
//  AnimatedStorybookApp.swift
//  AnimatedStorybook
//
//  Created by Caleb Bellmyer on 4/30/25.
//

import SwiftUI

@main
struct AnimatedStorybookApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
