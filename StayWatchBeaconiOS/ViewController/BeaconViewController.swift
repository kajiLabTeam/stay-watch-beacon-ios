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
            print("KeyChaneユーザの読み込みに失敗したドン。。。")
            self.signIn(firebaseAuth: firebaseAuth, peripheral: peripheral, keyChain: keyChain)
            return
        }

        let token = String(decoding: data, as: UTF8.self)
        print("トークンはなーんだ")
        print(token)

        // ユーザ情報の取得、保存、アドバタイズ開始までやる
        if let _ = firebaseAuth.getUserByToken(token: token, peripheral: peripheral) {
            print("トークンが正しくありません")
            self.signIn(firebaseAuth: firebaseAuth, peripheral: peripheral, keyChain: keyChain)
        } else {
            print("ユーザ情報の保存に成功")
        }
        print("同期開始")
    }

    func signIn(firebaseAuth:FirebaseAuthenticationModel, peripheral:PeripheralModel, keyChain:KeyChainModel){
        // トークンの取得、保存、ユーザ情報取得、保存、アドバタイズ開始までやる
        firebaseAuth.googleAuth(peripheral: peripheral, keyChainModel: keyChain)
    }
    
    func isAdvertising(peripheral: PeripheralModel) -> Bool {
        return peripheral.isAdvertising
    }

    func startAdvertising(peripheral: PeripheralModel) {
        let advertiseUUIDModel = AdvertiseUUIDModel()
        
        print("アドバタイズスタート")
        peripheral.stopAdvertising()    // 更新するために一回停止させる
        peripheral.startAdvertisingWithOption()
    }

    func stopAdvertising(peripheral: PeripheralModel) {
        print("アドバタイズストップ")
        peripheral.stopAdvertising()
    }
}
