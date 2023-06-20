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

    var body: some View {
        // Argument
        VStack {
            Text(argument)
        }
        // Peripheral
        VStack {
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
            Text(centralManager.serviceUUIDString)

            Button(action: {
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
