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
        .backgroundTask(.appRefresh("com.togawakouta.StayWatchBeaconiOS.appRefresh")) {
            await scheduleTestNotification()
//            await DataFetchHelper.shared.startRequestingRemoteData()
        }
    }
    
    func scheduleTestNotification() async {
        
        print("1分後に起きる処理が実行されたよ")
        text = "Background OK"
    }
}
