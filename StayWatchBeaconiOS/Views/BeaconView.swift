//
//  BeaconView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/07/05.
//

import Foundation

import SwiftUI
import CoreBluetooth

struct BeaconView: View {
    
    @StateObject var peripheral = PeripheralModel()
    @StateObject var firebaseAuth = FirebaseAuthenticationModel()
    @StateObject var viewController = BeaconViewController()
    @StateObject var keyChain = KeyChainModel()
    @ObservedObject var user = UserUtil()
    
    var body: some View {
        VStack {
            //if(firebaseController.email == ""){
            if(user.email == ""){
                SigninView(viewController: viewController, firebaseAuth: firebaseAuth, peripheral: peripheral, keyChain: keyChain)
                
            }else{
                // 上の研究室名、メールアドレス、サインインの部分
                HeaderView(viewController: viewController, firebaseAuth: firebaseAuth, peripheral: peripheral, keyChain: keyChain, user: user)
                    .padding(.horizontal, 5)    // 線
                
                // 下のビーコン関連の部分
                BeaconStatusView(viewController: viewController, firebaseAuth: firebaseAuth, peripheral: peripheral, keyChain: keyChain, user: user)
            }
        }
    }
}
