//
//  BeaconViewController.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/07/28.
//

import Foundation
import SwiftUI

class BeaconViewController: ObservableObject {
    
    func synchUser (keyChain:KeyChainModel, firebaseAuth:FirebaseAuthenticationModel, peripheral:PeripheralModel) {
        guard let data = keyChain.get() else {
            print("KeyChaneユーザの読み込みに失敗")
            self.signIn(firebaseAuth: firebaseAuth, peripheral: peripheral, keyChain: keyChain)
            return
        }
        let token = String(decoding: data, as: UTF8.self)
        
        // ユーザ情報の取得、保存、アドバタイズ開始までやる(エラーチェックありの非同期処理にしたい)
        firebaseAuth.getUserByToken(token: token, peripheral: peripheral, keyChain: keyChain)
    }

    func signIn(firebaseAuth:FirebaseAuthenticationModel, peripheral:PeripheralModel, keyChain:KeyChainModel){
        // トークンの取得、保存、ユーザ情報取得、保存、アドバタイズ開始までやる
        firebaseAuth.googleAuth(peripheral: peripheral, keyChainModel: keyChain)
    }
    
//    func isAdvertising(peripheral: PeripheralModel) -> Bool {
//        return peripheral.isAdvertising
//    }

    func startAdvertising(peripheral: PeripheralModel) {
        peripheral.stopAdvertising()    // 更新するために一回停止させる
        peripheral.startAdvertisingWithOption()
        UserDefaults.standard.set(true, forKey: "isAllowedAdvertising")
    }

    func stopAdvertising(peripheral: PeripheralModel) {
        peripheral.stopAdvertising()
        // オーバーフロー領域に入った部分は止めることができないため異なるUUIDで書き換える
        peripheral.startAdvertisingTmpUuid()
        UserDefaults.standard.set(false, forKey: "isAllowedAdvertising")
    }
}
