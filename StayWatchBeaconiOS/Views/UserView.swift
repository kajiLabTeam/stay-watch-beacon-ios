//
//  UserView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/06/21.
//

import SwiftUI
import Foundation
//import Firebase

struct ResponseUser: Codable {
    var results: [ResultUser]
}

struct ResultUser: Codable {
    var id: Int
    var name: String?
    var uuid: String?
    var email: String?
    var role: Int?
    var communityId: Int?
    var communityName: String?
}

struct UserView: View {
    @State private var results = [ResultUser]()   // 空の書籍情報配列を生成
    
//    let currentUser = FIRAuth.auth()?.currentUser
//    currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
//        if let error = error {
//            // Handle error
//            return;
//        }
//
//        // Send token to your backend via HTTPS
//        // ...
//    }
    
    var body: some View {
        VStack {
//            List(results, id: \.id) { user in
//                if let name = user.name {
//                    Text(name)
//                } else {
//                    Text("No name")
//                }
//            }
            List(results, id: \.id) { user in
                if let uuid = user.uuid {
                    Text(uuid)
                } else {
                    Text("No name")
                }
            }
        }.onAppear(perform: loadData)           // データ読み込み処理
    }
    
    /// データ読み込み処理
    func loadData() {
        
        print("データ読み込み処理開始")
        
        /// URLの生成
        guard let url = URL(string: "https://go-staywatch.kajilab.tk/api/v1/admin/users/2") else {
            /// 文字列が有効なURLでない場合の処理
            return
        }
        
        /// URLリクエストの生成
        print("URLリクエストの生成開始")
        let request = URLRequest(url: url)
        
        /// URLにアクセス
        print("URLリクエストへアクセス開始")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("データの取得チェック")
            if let data = data {    // ①データ取得チェック
                
                print("データの中身")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                
                /// ②JSON→Responseオブジェクト変換
                let decoder = JSONDecoder()
                do {
                    let decodedResponse = try decoder.decode([ResultUser].self, from: data)
                    DispatchQueue.main.async {
                        self.results = decodedResponse
                    }
                } catch {
                    print("JSON decode エラー: \(error)")
                }
                
            } else {
                /// ④データが取得できなかった場合の処理
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
            
        }.resume()      // タスク開始処理（必須）
    }
}
