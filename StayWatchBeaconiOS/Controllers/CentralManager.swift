//
//  CentralManager.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/06/07.
//

import Foundation
import CoreBluetooth

// CentralManagerは、セントラル（Apple Watch）の役割を担当するクラスです
class CentralManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var isConnected = false
    @Published var isScanning = false
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    var sumScanning = 0
    @Published var rssis:[Int] = []
    let serviceUUIDString = "e7d61ea3-f8dd-49c8-8f2f-f24a0020002e"  // 見せるだけのやつ
    //let serviceUUID = CBUUID(string: "0000feaa-0000-1000-8000-00805f9b34fb")  // iBeaconのBLE
    let serviceUUID = CBUUID(string: "e7d61ea3-f8dd-49c8-8f2f-f24a0020002e")    // iPhoneのBLE
    let characteristicUUID = CBUUID(string: "74278bda-b644-4520-8f0c-720eaf059935") // 今回はUUIDの形式ならなんでもよい
    
    @Published var isOneMeterAway = false
    
    
    var rssiUpdateTimer: Timer?
    
    
    
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("初期化(Central)")
    }
    
    //centralManagerDidUpdateStateメソッドで、セントラルマネージャの状態(central.state)が変更されたことを検知します。
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("セントラルマネージャの状態の変更を検知")
        print("state: \(central.state)")
        if central.state == .poweredOn {
            print("Central Manager is powered on.")
            // 将来的にここにスキャン開始処理を書く（power offだとスキャン不可なため）
        } else {
            print("Central Manager is not powered on.")
        }
    }
    
    //startScanningメソッドで、指定されたサービスUUIDを持つペリフェラルをスキャンします。
    func startScanning() {
        print("スキャン開始")
        isScanning = true
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
    
    
    // ペリフェラルを検出したときに呼ばれるメソッドです。サービス見つかった時に呼ばれるデリゲートメソッド
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("ペリフェラル（送信機）を検出したよ")
        //let uuid = peripheral.identifier.uuidString
        //print(name)
        //print(uuid)
        self.peripheral = peripheral
        
        // リストへRSSIの値を保存する
        rssis.append(RSSI.intValue)
        
        // スキャンを停止する
        stopScanning()
        startScanning()
    }
    
    // BLEの受信終了
    func stopScanning() {
        print("受信終了")
        isScanning = false
        centralManager.stopScan()
    }
}
