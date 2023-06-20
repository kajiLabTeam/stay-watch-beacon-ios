//
//  PeripheralManager.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/06/07.
//

import Foundation
import CoreBluetooth
import UIKit

//Bluetoothペリフェラルとしてカウントを管理するクラス
class PeripheralManager: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    
    
    //     カウントを管理するPublishedプロパティ
    @Published var count = 0
    @Published var isAdvertising = false
    // Bluetoothペリフェラルマネージャ
    var peripheralManager: CBPeripheralManager!
    // サービスとキャラクタリスティックのUUID
    let serviceUUID = CBUUID(string: "e7d61ea3-f8dd-49c8-8f2f-f24a0020002e")
    let characteristicUUID = CBUUID(string: "b37e1ccd-b930-a45e-abef-07f9232b5a81")
    
    
    override init() {
        super.init()
        // let options: Dictionary = [CBPeripheralManagerOptionRestoreIdentifierKey: "staywatchPeripheralRestoreIdentifierKey"]
        let options: Dictionary = [CBPeripheralManagerOptionRestoreIdentifierKey: "com.togawakouta.StayWatchBeaconiOS"]
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
        // peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    // ペリフェラルマネージャの状態が更新されたときに呼ばれるデリゲートメソッド
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        // ペリフェラルマネージャの状態に応じたメッセージを出力
        if peripheral.state == .poweredOn {
            print("Peripheral Manager is powered on.")
            startAdvertising()
        } else {
            print("Peripheral Manager is not powered on.")
        }
    }
    
    
    // アドバタイズを開始するメソッド
    func startAdvertising() {
        // サービスとキャラクタリスティックを作成し、ペリフェラルマネージャに追加
        let service = CBMutableService(type: serviceUUID, primary: true)
        let characteristic = CBMutableCharacteristic(type: characteristicUUID, properties: .write, value: nil, permissions: .writeable)
        service.characteristics = [characteristic]
        peripheralManager.add(service)
        let serviceUUIDs = [serviceUUID]
        let advertisementData: [String: Any] = [
            CBAdvertisementDataLocalNameKey: "kjlb-iPhone11pro",
            CBAdvertisementDataServiceUUIDsKey: serviceUUIDs
        ]
        // アドバタイズ開始
        print("アドバタイズ開始")
        //peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [serviceUUID]])
        peripheralManager.startAdvertising(advertisementData)
        isAdvertising = true
    }

    // アドバタイズを終了するメソッド
    func stopAdvertising() {
        print("アドバタイズ終了")
        peripheralManager.stopAdvertising()
        isAdvertising = false
    }
    
        // ペリフェラルマネージャの状態が更新されたときに呼ばれるデリゲートメソッド（バックグラウンド版）
//        func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//            // ペリフェラルマネージャの状態に応じたメッセージを出力
//            if peripheral.state == .poweredOn {
//                print("Peripheral Manager is powered on.")
//                startAdvertising() // バックグラウンドでもアドバタイズを開始
//            } else {
//                print("Peripheral Manager is not powered on.")
//            }
//        }
    //
    // サービスが追加されたときに呼ばれるデリゲートメソッド
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        // エラーがある場合はエラー内容を出力、なければ成功メッセージを出力
        if let error = error {
            print("Error adding service: \(error.localizedDescription)")
        } else {
            print("Service added successfully.")
        }
    }
    
    // 復元時に呼ばれる
    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        print("ペリフェラル復元: \(dict)")
        startAdvertising()
        
        // バックグラウンドではローカル通知を発行
//        if UIApplication.shared.applicationState != .active {
//            let content = UNMutableNotificationContent()
//            content.body = msg
//            content.sound = .default
//
//            let request = UNNotificationRequest(identifier: "RestorationNotification", content: content, trigger: nil)
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//        }
    }
    
    
//        func applicationWillResignActive(_ application: UIApplication) {
//            print("バックグラウンドになったよ")
//            // バックグラウンドで行いたい処理があるとき
//            backgroundTaskID = application.beginBackgroundTask(expirationHandler: {
//                [weak self] in
//                application.endBackgroundTask((self?.backgroundTaskID)!)
//                self?.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
//            })
//        }
//
//        func applicationDidBecomeActive(_ application: UIApplication) {
//            // タスクの解除
//            application.endBackgroundTask(backgroundTaskID)
//        }
}

