//
//  testWatchApp.swift
//  testWatch Watch App
//
//  Created by Martin Rost on 24.01.25.
//

import SwiftUI

@main
struct testWatch_Watch_AppApp: App {
    
    @StateObject var manager = WatchCommunicationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(manager)
        }
    }
}
