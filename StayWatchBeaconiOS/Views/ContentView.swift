//
//  ContentView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/05/18.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @StateObject var centralManager = CentralManager()
    
    var body: some View {
        VStack {
//            if centralManager.isConnected {
//                Text("接続済み")
//                    .font(.largeTitle)
//            } else {
//                Text("未接続")
//                    .font(.largeTitle)
//            }
            Text("据え置き型BLEビーコン")
            
            
            
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
    }
}

// 初期のContentView
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Hello, Beacon!!!")
//        }
//        .padding()
//    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
