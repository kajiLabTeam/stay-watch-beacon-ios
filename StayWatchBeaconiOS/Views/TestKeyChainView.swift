//
//  TestKeyChainView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/07/12.
//

import Foundation
import SwiftUI
import CoreBluetooth

// Centralを見るためのContentView
struct TestKeyChainView: View {
    
    @StateObject var tokenStorage = TokenStorage()
    
    func getToken() {
        guard let data = tokenStorage.get() else {
            print("パスワードの読み込みに失敗したドン。。。")
            return
        }

        let token = String(decoding: data, as: UTF8.self)
        print("パスワードはなーんだ \(token)")
    }
    
    var body: some View {
        VStack {
            Button(action: {
                getToken()
            }) {
                Text("取得する")
                    .font(.title)
            }
            
            Button(action: {
                do {
                    try tokenStorage.save(token: "sampleTokenyJhbGciOiJFUzI1NiIsImtpZCI6IjllciJ9.eyJhdWQiOiJodHRwczovL2JhY2tlbmQuZXhhbXBsZS5jb20iLCJpc3MiOiJodHRwczovL2FzLmV4YW1wbGUuY29tIiwiZXhwIjoxNDQxOTE3NTkzLCJpYXQiOjE0NDE5MTc1MzMsImF6cCI6InJzMDgiLCJzdWIiOiJiY0BleGFtcGxlLmNvbSIsInNjcCI6WyJhcGkiXX0.vHJKtJ-zFIN75Tk7qGlmQsWPlvnChb2uSaGwPLvlWl64ts7-vvfwYDaVoXIQe_HkTVdljIzavVlPT60_b_9pD")
                }
                catch {
                    print(error)
                }
            }) {
                Text("保存する")
                    .font(.title)
            }
            
            Button(action: {
                do {
                    try tokenStorage.delete()
                }
                catch {
                    print(error)
                }
            }) {
                Text("削除する")
                    .font(.title)
            }
        }
    }
}
