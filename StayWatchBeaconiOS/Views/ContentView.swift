//
//  ContentView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/05/18.
//

import SwiftUI
import CoreBluetooth

// Centralを見るためのContentView
struct ContentView: View {
    var argument: String
    
    @StateObject var centralManager = CentralManager()
    @StateObject var peripheralManager = PeripheralManager()
    @StateObject var backgroundManager = BackgroundManager()

    var body: some View {
        // Argument
        VStack {
            Text(argument)
        }
        // Background
        VStack {
            Button(action: {
                backgroundManager.getTasks()
            }) {
                Text("スケジュール一覧")
                    .font(.title)
            }
            Button(action: {
                print("スケジュール予約ボタンが押されたよ")
                backgroundManager.createSchedule()
            }) {
                Text("スケジュール予約")
                    .font(.title)
            }
        }
        // Peripheral
        VStack {
            Text("Countしないよ")
                .font(.largeTitle)
                .padding(10)
            Button(action: {
                if peripheralManager.isAdvertising {
                    peripheralManager.stopAdvertising()
                }else {
                    peripheralManager.startAdvertising()
                }
            }) {
                Text(peripheralManager.isAdvertising ? "送信終了" : "送信開始")
                    .font(.title)
            }
        }
        // Central
        VStack {
//            if centralManager.isConnected {
//                Text("接続済み")
//                    .font(.largeTitle)
//            } else {
//                Text("未接続")
//                    .font(.largeTitle)
//            }
            Text(centralManager.serviceUUIDString)



//            if centralManager.isOneMeterAway {
//                Text("1メートル以内です")
//                    .font(.headline)
//            } else {
//                Text("1メートル以上離れています")
//                    .font(.headline)
//            }


            Button(action: {
//                if centralManager.isConnected {
//                    centralManager.incrementCounter()
//                } else {
//                    centralManager.startScanning()
//                }
                if centralManager.isScanning {
                    centralManager.stopScanning()
                }else{
                    centralManager.startScanning()
                }

            }) {
                Text(centralManager.isScanning ? "受信終了" : "受信開始")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            List(centralManager.rssis, id: \.self) { rssi in
                Text(String(rssi))
            }
        }
        
        // graph
        ChartView(y:centralManager.rssis)
    }
}


struct ContentView_Previews: PreviewProvider {
    private var argument = "hello previews"
    static var previews: some View {
        ContentView(argument: "Hello previews")
    }
}
