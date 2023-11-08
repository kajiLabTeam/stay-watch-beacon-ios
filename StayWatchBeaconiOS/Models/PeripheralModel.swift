//
//  PeripheralModel.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/07/31.
//

import Foundation
import CoreBluetooth

class PeripheralModel: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    
    
    //     カウントを管理するPublishedプロパティ
    @Published var count = 0
    @Published var isAdvertising = false
    @Published var serviceUUIDStr = "00000000-0000-0000-0000-000000000000"
    @Published var advertisingServiceUUIDStr = "e7d61ea3-f8dd-49c8-8f2f-f24a0020002e"
    // Bluetoothペリフェラルマネージャ
    var peripheralManager: CBPeripheralManager!
    
    let advertiseUUIDModel = AdvertiseUUIDModel()
    // サービスとキャラクタリスティックのUUID
    let characteristicUUID = CBUUID(string: "b37e1ccd-b930-a45e-abef-07f9232b5a81")
    
    override init() {
        super.init()
        let options: Dictionary = [CBPeripheralManagerOptionRestoreIdentifierKey: "com.togawakouta.StayWatchBeaconiOS"]
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
        // peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        // UUIDを保存されている場合そのUUIDに設定する
        if let uuid = UserDefaults.standard.string(forKey: "uuid") {
            serviceUUIDStr = uuid
        }
    }
    
    // ペリフェラルマネージャの状態が更新されたときに呼ばれるデリゲートメソッド
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        // ペリフェラルマネージャの状態に応じたメッセージを出力
        if peripheral.state == .poweredOn {
            print("Peripheral Manager is powered on.")
            startAdvertisingWithOption()
            //startAdvertising(advertisementData: [String : "b37e1ccd-b930-a45e-abef-07f9232b5a81"])
        } else {
            print("Peripheral Manager is not powered on.")
        }
    }
    
    
    // アドバタイズを開始するメソッド
    func startAdvertisingWithOption() {
        // サービスとキャラクタリスティックを作成し、ペリフェラルマネージャに追加
        //serviceUUIDStr = UserDefaults.standard.string(forKey: "uuid")
        if let tmpServiceUUIDStr = UserDefaults.standard.string(forKey: "uuid"){
            // nilでない場合
            serviceUUIDStr = UserDefaults.standard.string(forKey: "uuid")!
        } else {
            // nilの場合
            print("アドバタイズ失敗")
            return
        }
        //serviceUUIDStr = "11111111-1111-1111-1111-07f9232b5a81"
        
        
        let serviceUUIDs = advertiseUUIDModel.generateAdvertisingUUIDs(inputUUID: serviceUUIDStr)
        let advertisementData: [String: Any] = [
            CBAdvertisementDataLocalNameKey: "StayWatchBeaconForiOS",
            CBAdvertisementDataServiceUUIDsKey: serviceUUIDs
        ]
        
        // アドバタイズ開始
        peripheralManager.startAdvertising(advertisementData)
        isAdvertising = true
        advertisingServiceUUIDStr = serviceUUIDStr
        
        print("アドバタイ図開始")
        print(serviceUUIDs)
    }
    
    // アドバタイズを終了するメソッド
    func stopAdvertising() {
        peripheralManager.stopAdvertising()
        isAdvertising = false
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
    
    // 復元時に呼ばれる
    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        //print("ペリフェラル復元: \(dict)")
    }
}

