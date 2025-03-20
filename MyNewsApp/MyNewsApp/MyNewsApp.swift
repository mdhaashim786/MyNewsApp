//
//  MyNewsAppApp.swift
//  MyNewsApp
//
//  Created by mhaashim on 19/03/25.
//

import SwiftUI

@main
struct MyNewsApp: App {
    let persistenceController = PersistenceController.shared

    @State var appColorMode: ColorScheme = .dark
    
    var body: some Scene {
        WindowGroup {
            ContentView(appColorMode: $appColorMode)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(appColorMode)
        }
    }
}
