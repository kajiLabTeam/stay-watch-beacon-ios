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
    
    @State var communityName = "梶研究室"
    @State var userName = "togawa"
    @State var uuid = "e7d61ea3-f8dd-49c8-8f2f-f24a0020002e"
    
    var body: some View {
        VStack {
            
            // 上の研究室名、メールアドレス、サインインの部分
            VStack {
                HStack {
                    Text(communityName)
                        .font(.title3)
                        .fontWeight(.medium)
                    Spacer()
                    VStack {
                        Text("別アカウントでサインイン")
                            .font(.caption)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .border(Color.yellow, width: 3.0)
                        Text("toge9113@gmail.com")
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
                    Text("発信中")
                        .padding()
                        .frame(width:290, height: 200)
                        .foregroundColor(Color.white)
                        .font(.system(size:54.0))
                    //.background(Color.red)
                        .background(Color.blue)
                        .cornerRadius(24)
//                    Spacer()
                    Text(userName)
                        .padding(.bottom, 5)
                        .padding(.top, 20)
                        .font(.title2)
                    Text(uuid)
                        .font(.caption)
                        .padding(.bottom, 5)
                    Image(systemName: "arrow.triangle.2.circlepath.circle")
                        .font(.system(size: 50))
                        .padding()
                }
                .padding()
            }
            .frame(width: 350, height: 400)
            .background(Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 0.1))
            .padding(.top)
            
            Text("発信を停止する")
                .padding()
                .foregroundColor(Color.gray)
            
            Spacer()
            
        }
    }
}


struct BeaconView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconView()
    }
}
