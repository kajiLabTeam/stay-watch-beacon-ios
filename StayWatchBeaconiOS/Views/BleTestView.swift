//
//  BleTestView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/06/23.
//

import Foundation

import SwiftUI
import CoreBluetooth

// Centralを見るためのContentView
struct BleTestView: View {
    var argument: String
    
    @StateObject var centralManager = CentralManager()
    @StateObject var peripheralManager = PeripheralManager()
    
    var body: some View {
        // users
        //UserView()
        // Argument
        //        VStack {
        //            Text(argument)
        //        }
        // Peripheral
        VStack {
            //            NavigationLink(destination: SigninView()){
            //                Text("サインイン画面へ")
            //            }
            
            TextField("UUID", text: $peripheralManager.serviceUUIDStr)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                if peripheralManager.isAdvertising {
                    peripheralManager.stopAdvertising()
                }else {
                    peripheralManager.startAdvertisingWithOption()
                }
            }) {
                Text(peripheralManager.isAdvertising ? "送信終了" : "送信開始")
                    .font(.title)
            }
            Text(peripheralManager.advertisingServiceUUIDStr)
        }
        // Central
        VStack {
            //Text(centralManager.serviceUUIDString)
            
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
        ChartView(y:centralManager.rssis, intervalSec:centralManager.intervalSec)
    }
}


struct BleTestView_Previews: PreviewProvider {
    private var argument = "hello previews"
    static var previews: some View {
        BleTestView(argument: "Hello previews")
    }
}
