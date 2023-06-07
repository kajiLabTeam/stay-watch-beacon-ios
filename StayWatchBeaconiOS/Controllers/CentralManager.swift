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
    @Published var rssis:[Int] = []
    //let serviceUUID = CBUUID(string: "378d5538-f7f9-d4c0-2167-c5afcd226353")
    let serviceUUIDString = "378D5538-F7F9-D4C0-2167-C5AFCD226353"
    let serviceUUID = CBUUID(string: "378D5538-F7F9-D4C0-2167-C5AFCD226353")
    let characteristicUUID = CBUUID(string: "74278bda-b644-4520-8f0c-720eaf059935")
    
    
    @Published var isOneMeterAway = false
    
    
    var rssiUpdateTimer: Timer?
    
    
    
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("初期化")
        
        
    }
    
    
    
    //startScanningメソッドで、指定されたサービスUUIDを持つペリフェラルをスキャンします。
    func startScanning() {
        print("スキャン開始")
        isScanning = true
        //centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
    }
    
    //centralManagerDidUpdateStateメソッドで、セントラルマネージャの状態(central.state)が変更されたことを検知します。
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("セントラルマネージャの状態の変更を検知")
        if central.state == .poweredOn {
            print("Central Manager is powered on.")
        } else {
            print("Central Manager is not powered on.")
        }
    }
    
    
    // ペリフェラルを検出したときに呼ばれるメソッドです。
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        //print("ペリフェラル（送信機）を検出したよ")
        let name = peripheral.name ?? "Unavailable"
        print(name)
        self.peripheral = peripheral
        
        if(peripheral.identifier.uuidString == serviceUUIDString){
            print("\(serviceUUIDString)のRSSI: \(RSSI)")
            rssis.append(RSSI.intValue)
        }
        
        //        if let rssiValue = advertisementData[CBAdvertisementDataRSSIKey] as? NSNumber {
        //            print("RSSI: \(rssiValue)")
        //        }
        
        
        
        //        検出されたペリフェラルに接続を試みます。接続が成功した場合、centralManager(_:didConnect:)デリゲートメソッドが呼ばれ、失敗した場合はcentralManager(_:didFailToConnect:error:)が呼ばれます。
        //central.connect(peripheral, options: nil)
        //        print(peripheral.identifier.uuidString)
        //        print(peripheral.identifier.)
    }
    
    
    // ペリフェラルに接続が成功した時、呼ばれるメソッドです。
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("ペリフェラルと接続成功")
        isConnected = true
        peripheral.delegate = self
        
        
        
        
        //        リフェラルデバイスのReceived Signal Strength Indicator（RSSI）を読み取るために使用されます
        //        peripheral(_:didReadRSSI:error:)デリゲートメソッドが呼び出されます
        peripheral.readRSSI()
        
        
        
        //         接続されたペリフェラルのサービスを探索します。
        //        サービスが見つかった場合、peripheral(_:didDiscoverServices:)デリゲートメソッドが呼ばれます
        peripheral.discoverServices([serviceUUID])
        
        
        //タイマーが1秒ごとにトリガーされるたびに実行されるクロージャです。このクロージャは、ペリフェラルデバイスのreadRSSI()メソッドを呼び出してRSSIを読み取ります。
        rssiUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            peripheral.readRSSI()}
    }
    
    
    
    
    
    
    //  ペリフェラルデバイスからRSSIが読み取られたときに、自動的に呼び出されます。
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print("RSSIのエラーチェック")
        if let error = error {
            print("Error reading RSSI: \(error.localizedDescription)")
            return
        }
        
        checkDistance(rssi: RSSI)
    }
    
    // BLEの受信終了
    func stopScanning() {
        print("受信終了")
        isScanning = false
        centralManager.stopScan()
    }
    
    
    
    
    
    // ペリフェラルへの接続が失敗したときに呼ばれるメソッドです。
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        print("Failed to connect to peripheral")
    }
    
    
    // ペリフェラルから切断されたときに呼ばれるメソッドです。
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        print("Disconnected from peripheral")
        
        
        //       切断時にタイマーを無効化する
        rssiUpdateTimer?.invalidate()
        rssiUpdateTimer = nil
        
    }
    
    
    // ペリフェラルのサービスが見つかったときに呼ばれるメソッドです。
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        //        サービスの検出中に何らかのエラーが発生,エラー内容をログに出力し、メソッドの実行を終了
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        if let services = peripheral.services {
            for service in services {
                //                サービスに関連するcharacteristicを検索するためのメソッド（didDiscoverCharacteristicsForデリゲートメソッド）を呼び出します
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }
    
    
    //    キャラクタリスティックが見つかったときに呼ばれるメソッドです。
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == characteristicUUID {
                    print("Found characteristic")
                }
            }
        }
    }
    
    //    カウンターをインクリメントするメソッドです。
    func incrementCounter() {
        guard let peripheral = peripheral, let characteristic = findCharacteristic() else { return }
        let value: UInt8 = 1
        let data = Data([value])
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
        
    }
    
    
    //    CentralとPeripheralデバイス間の距離が約1メートルかどうかを判断
    
    func checkDistance(rssi: NSNumber) {
        //             rssi引数を受け取り、rssi.intValueで整数値に変換
        let rssiValue = rssi.intValue
        //           次に、約1メートルの閾値としてoneMeterRSSIThreshold変数に-60を設定
        let oneMeterRSSIThreshold = -80
        
        if rssiValue > oneMeterRSSIThreshold {
            //                 1メートル以内であると判断します
            isOneMeterAway = true
        } else {
            isOneMeterAway = false
        }
    }
    
    
    //    補助関数であり、特定のキャラクタリスティックを検索する、incrementCounter()関数）でキャラクタリスティックを操作するために使用
    func findCharacteristic() -> CBCharacteristic? {
        guard let services = peripheral?.services else { return nil }
        for service in services {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    if characteristic.uuid == characteristicUUID {
                        return characteristic
                    }
                }
            }
        }
        return nil
    }
}