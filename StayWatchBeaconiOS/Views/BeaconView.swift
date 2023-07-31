//
//  BeaconView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/07/05.
//

import Foundation

import SwiftUI
import CoreBluetooth

// Centralを見るためのContentView
struct BeaconView: View {
    
    @StateObject var peripheral = PeripheralModel()
    @StateObject var firebaseAuth = FirebaseAuthenticationModel()
    @StateObject var tokenStorage = TokenStorage()
    @StateObject var viewController = BeaconViewController()
    @StateObject var keyChain = KeyChainModel()

    let IPHONE_CHARACTER:Character = "a"
//    //var user = UserState(name: "", uuid: "", email: "", communityName: "", latestSyncTime: "")
    @ObservedObject var user = UserUtil()
    
    var body: some View {
        VStack {
            //if(firebaseController.email == ""){
            if(user.email == ""){
                Spacer()
                Group{
                    Text("滞在ウォッチ用ビーコン")
                    Text("for iOS")
                }
                .font(.title)
                Spacer()
                Button(action: {
                    viewController.signIn(firebaseAuth: firebaseAuth, peripheral: peripheral, keyChain: keyChain)
                }) {
                    Text("Googleアカウントでサインイン")
                        .padding()
                        .foregroundColor(Color.black)
                        .font(.title2)
                        .background(Color.yellow)
                        .cornerRadius(10)
                }
                Spacer()
                
            }else{
                // 上の研究室名、メールアドレス、サインインの部分
                VStack {
                    HStack {
                        //Text(firebaseController.communityName)
                        Text(user.communityName)
                            .font(.title3)
                            .fontWeight(.medium)
                        Spacer()
                        VStack {
                            Button(action: {
//                                firebaseController.googleAuth(peripheral: peripheralManager, tokenStorage: tokenStorage)
                                viewController.signIn(firebaseAuth: firebaseAuth, peripheral: peripheral, keyChain: keyChain)
                            }) {
                                Text("別のアカウントでサインイン")
                                    .font(.caption)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal)
                                    .border(Color.yellow, width:3.0)
                                    .foregroundColor(Color.black)
                            }
                            //Text(firebaseController.email)
                            Text(user.email)
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal, 5)
                    Divider()
                }
                .padding(.horizontal, 5)
                
                // 下のビーコン関連の部分
                VStack {
                    VStack {
                        //if(firebaseController.uuid == ""){
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
                            Text(viewController.isAdvertising(peripheral: peripheral) ? "発信中" : "停止中")
                                .padding()
                                .frame(width:290, height: 200)
                                .foregroundColor(Color.white)
                                .font(.system(size:54.0))
                            //.background(Color.red)
                                .background(viewController.isAdvertising(peripheral: peripheral) ? Color.blue : Color.red)
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
                                .foregroundColor(Color.black)
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
                //if(firebaseController.uuid != "" && firebaseController.uuid.dropFirst(27).first == "a"){
                if(user.uuid != "" && user.uuid.dropFirst(27).first == IPHONE_CHARACTER){
                    Button(action: {
                        if viewController.isAdvertising(peripheral: peripheral) {
                            viewController.stopAdvertising(peripheral: peripheral)
                        }else{
                            viewController.startAdvertising(peripheral: peripheral)
                        }
                        
                    }) {
                        Text(viewController.isAdvertising(peripheral: peripheral) ? "発信を停止する" : "発信を開始する")
                            .padding()
                            .foregroundColor(Color.gray)
                    }
                }
                
                Spacer()
                
            }
        }
    }
}


//struct BeaconView_Previews: PreviewProvider {
//    static var previews: some View {
//        BeaconView()
//    }
//}
