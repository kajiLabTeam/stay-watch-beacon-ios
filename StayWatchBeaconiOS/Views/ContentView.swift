//
//  ContentView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/05/18.
//

import SwiftUI
import CoreBluetooth

//Bluetoothペリフェラルとしてカウントを管理するクラス
class PeripheralManager: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    
    //     カウントを管理するPublishedプロパティ
    @Published var count = 0
    @Published var isAdvertising = false
    // Bluetoothペリフェラルマネージャ
    var peripheralManager: CBPeripheralManager!
    // サービスとキャラクタリスティックのUUID
    let serviceUUID = CBUUID(string: "b37e1ccd-b930-a45e-abef-07f9232b5a80")
    let characteristicUUID = CBUUID(string: "b37e1ccd-b930-a45e-abef-07f9232b5a81")
    
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
    
    
    // アドバタイズを開始するメソッド
    func startAdvertising() {
        // サービスとキャラクタリスティックを作成し、ペリフェラルマネージャに追加
        let service = CBMutableService(type: serviceUUID, primary: true)
        let characteristic = CBMutableCharacteristic(type: characteristicUUID, properties: .write, value: nil, permissions: .writeable)
        service.characteristics = [characteristic]
        peripheralManager.add(service)
        // アドバタイズ開始
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [serviceUUID]])
        isAdvertising = true
    }
    
    // アドバタイズを終了するメソッド
    func stopAdvertising() {
        peripheralManager.stopAdvertising()
        isAdvertising = false
    }
    
    // ペリフェラルマネージャの状態が更新されたときに呼ばれるデリゲートメソッド
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        // ペリフェラルマネージャの状態に応じたメッセージを出力
        if peripheral.state == .poweredOn {
            print("Peripheral Manager is powered on.")
        } else {
            print("Peripheral Manager is not powered on.")
        }
    }
    
    // サービスが追加されたときに呼ばれるデリゲートメソッド
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        // エラーがある場合はエラー内容を出力、なければ成功メッセージを出力
        if let error = error {
            print("Error adding service: \(error.localizedDescription)")
        } else {
            print("Service added successfully.")
        }
    }
}

// Peripheralを見るためのContentView
struct ContentView: View {
    @StateObject var peripheralManager = PeripheralManager()
    
    var body: some View {
        VStack {
            Text("Countしないよ")
                .font(.largeTitle)
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
    }
}


// Centralを見るためのContentView
//struct ContentView: View {
//    @StateObject var centralManager = CentralManager()
//
//    var body: some View {
//        // Central
//        VStack {
////            if centralManager.isConnected {
////                Text("接続済み")
////                    .font(.largeTitle)
////            } else {
////                Text("未接続")
////                    .font(.largeTitle)
////            }
//            Text("据え置き型BLEビーコン")
//
//
//
////            if centralManager.isOneMeterAway {
////                Text("1メートル以内です")
////                    .font(.headline)
////            } else {
////                Text("1メートル以上離れています")
////                    .font(.headline)
////            }
//
//
//            Button(action: {
////                if centralManager.isConnected {
////                    centralManager.incrementCounter()
////                } else {
////                    centralManager.startScanning()
////                }
//                if centralManager.isScanning {
//                    centralManager.stopScanning()
//                }else{
//                    centralManager.startScanning()
//                }
//
//            }) {
//                Text(centralManager.isScanning ? "受信終了" : "受信開始")
//                    .font(.title)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//
//            List(centralManager.rssis, id: \.self) { rssi in
//                Text(String(rssi))
//            }
//        }
//    }
//}

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
