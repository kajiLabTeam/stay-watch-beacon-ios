//
//  BeaconStatusView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/08/01.
//

import Foundation
import SwiftUI

struct BeaconStatusView: View {
    @StateObject var viewController: BeaconViewController
    @StateObject var firebaseAuth: FirebaseAuthenticationModel
    @StateObject var peripheral: PeripheralModel
    @StateObject var keyChain: KeyChainModel
    @ObservedObject var user: UserUtil
    
    @Environment(\.colorScheme) var colorScheme
    let IPHONE_CHARACTER:Character = "1"
    
    var body: some View {
        VStack {
            VStack {
                if(user.name == ""){
                    Text("未登録")
                        .padding()
                        .frame(width:290, height: 200)
                        .foregroundColor(Color.red)
                        .font(.system(size:54.0))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.red, lineWidth: 5)
                        )
                    Text("このメールアドレスは")
                        .padding(.top, 20)
                    Text("登録されていません")
                        .padding(.bottom, 5)
                    //}else if(firebaseController.uuid.dropFirst(27).first != "a"){
                }else if(user.uuid.dropFirst(27).first != IPHONE_CHARACTER){
                    Text("未登録")
                        .padding()
                        .frame(width:290, height: 200)
                        .foregroundColor(Color.red)
                        .font(.system(size:54.0))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.red, lineWidth: 5)
                        )
                    Text("アプリビーコンとして")
                        .padding(.top, 20)
                    Text("登録されていません")
                        .padding(.bottom, 5)
                }else{
                    Text(user.isAllowedAdvertising ? "発信中" : "停止中")
                        .padding()
                        .frame(width:290, height: 200)
                        .foregroundColor(Color.white)
                        .font(.system(size:54.0))
                    //.background(Color.red)
                        .background(user.isAllowedAdvertising ? Color.blue : Color.red)
                        .cornerRadius(24)
                    //Text(firebaseController.userName)
                    Text(user.name)
                        .padding(.bottom, 5)
                        .padding(.top, 20)
                        .font(.title2)
                    //Text(firebaseController.uuid)
                    Text(user.uuid)
                        .font(.caption)
                        .padding(.bottom, 5)
                }
                Button(action: {
                    viewController.synchUser(keyChain: keyChain, firebaseAuth: firebaseAuth, peripheral: peripheral)
                }) {
                    Image(systemName: "arrow.triangle.2.circlepath.circle")
                        .font(.system(size: 50))
                        .padding(.top)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                //Text("最新の同期：\(synchoronizationTime)")
                Text("最新の同期：\(user.latestSyncTime)")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .padding(.bottom)
            }
            .padding()
        }
        .frame(width: 350, height: 400)
        .background(Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 0.1))
        .padding(.top)
        
        // 登録情報があったら発信の開始・停止ボタンを表示する
        if(user.uuid != "" && user.uuid.dropFirst(27).first == IPHONE_CHARACTER){
            Button(action: {
                if user.isAllowedAdvertising {
                    viewController.stopAdvertising(peripheral: peripheral)
                }else{
                    viewController.startAdvertising(peripheral: peripheral)
                }
                
            }) {
                Text(user.isAllowedAdvertising ? "発信を停止する" : "発信を開始する")
                    .padding()
                    .foregroundColor(Color.gray)
            }
        }
        
        Spacer()
    }
}
