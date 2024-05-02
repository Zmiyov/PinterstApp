//
//  PinterstAppApp.swift
//  PinterstApp
//
//  Created by Vladimir Pisarenko on 02.05.2024.
//

import SwiftUI

@main
struct PinterstAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        //hiding title bar
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
