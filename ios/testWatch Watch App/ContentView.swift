//
//  ContentView.swift
//  testWatch Watch App
//
//  Created by Martin Rost on 24.01.25.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var manager: WatchCommunicationManager
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(manager.text ?? "XXX")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
