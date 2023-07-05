//
//  ContentView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/05/18.
//

import SwiftUI
import CoreBluetooth

// Centralを見るためのContentView
struct ContentView: View {
    
    
    var body: some View {

        NavigationView{
            VStack {
                NavigationLink(destination: OpenCampusBasicView()){
                    Text("オーキャン（BLEの紹介）")
                        .padding(5)
                }
                NavigationLink(destination: OpenCampusWheelView()){
                    Text("オーキャン（車椅子への応用）")
                        .padding(5)
                }
                NavigationLink(destination: BleTestView(argument: "Hello previews")){
                    Text("BLEテスト画面へ")
                }
                NavigationLink(destination: SigninView()){
                    Text("Signin画面へ")
                }
                NavigationLink(destination: BeaconView()){
                    Text("本番アプリへ")
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
