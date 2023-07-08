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
    
    @StateObject var peripheralManager = PeripheralManager()
    @StateObject var firebaseController = FirebaseAuthController()
    
    @State var synchoronizationTime = "2023/04/01 11:53"
    
    var body: some View {
        VStack {
            if(firebaseController.email == ""){
                Spacer()
                Group{
                    Text("滞在ウォッチ用ビーコン")
                    Text("for iOS")
                }
                .font(.title)
                Spacer()
                Button(action: {
                    firebaseController.googleAuth(peripheral: peripheralManager)
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
                        Text(firebaseController.communityName)
                            .font(.title3)
                            .fontWeight(.medium)
                        Spacer()
                        VStack {
                            Button(action: {
                                //print(type(of: peripheralManager))
                                firebaseController.googleAuth(peripheral: peripheralManager)
                            }) {
                                Text("別アカウントでサインイン")
                                    .font(.caption)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal)
                                    .border(Color.yellow, width:3.0)
                                    .foregroundColor(Color.black)
                            }
                            Text(firebaseController.email)
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
                        if(firebaseController.uuid == ""){
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
                        }else{
                            Text(peripheralManager.isAdvertising ? "発信中" : "停止中")
                                .padding()
                                .frame(width:290, height: 200)
                                .foregroundColor(Color.white)
                                .font(.system(size:54.0))
                            //.background(Color.red)
                                .background(peripheralManager.isAdvertising ? Color.blue : Color.red)
                                .cornerRadius(24)
                            Text(firebaseController.userName)
                                .padding(.bottom, 5)
                                .padding(.top, 20)
                                .font(.title2)
                            Text(firebaseController.uuid)
                                .font(.caption)
                                .padding(.bottom, 5)
                        }
                        Button(action: {
                            firebaseController.googleAuth(peripheral: peripheralManager)
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath.circle")
                                .font(.system(size: 50))
                                .padding(.top)
                                .foregroundColor(Color.black)
                        }
                        Text("最新の同期：\(synchoronizationTime)")
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
                if(firebaseController.uuid != ""){
                    Button(action: {
                        if peripheralManager.isAdvertising {
                            peripheralManager.stopAdvertising()
                        }else{
                            peripheralManager.startAdvertisingWithOption()
                        }
                        
                    }) {
                        Text(peripheralManager.isAdvertising ? "発信を停止する" : "発信を開始する")
                            .padding()
                            .foregroundColor(Color.gray)
                    }
                }
                
                Spacer()
                
            }
        }
    }
}


struct BeaconView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconView()
    }
}
