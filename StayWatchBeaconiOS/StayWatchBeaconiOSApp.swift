//
//  StayWatchBeaconiOSApp.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/05/18.
//

import SwiftUI

@main
struct StayWatchBeaconiOSApp: App {
    @State private var text = "Hello, World!"
    var body: some Scene {
        WindowGroup {
            ContentView(argument: text)
        }
    }
}
