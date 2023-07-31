//
//  FirebaseAuthenticationModel.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/07/31.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

import Alamofire

struct User: Codable {
    let id: Int
    let role: Int
    let uuid: String
    let name: String
    let communityId: Int
    let communityName: String
}

class FirebaseAuthenticationModel: NSObject, ObservableObject{
    
    var email = ""
    var communityName = "none"
    var userName = "none"
    var uuid = ""
    var latestSyncTime = ""
    
    override init() {
        super.init()
    }
    
    private func convertToUUIDFormat(rawUuid: String) -> String {
        
        let outputUUID = String(
            format: "%@-%@-%@-%@-%@",
            String(rawUuid.prefix(8)),
            String(rawUuid.prefix(12).suffix(4)),
            String(rawUuid.prefix(16).suffix(4)),
            String(rawUuid.prefix(20).suffix(4)),
            String(rawUuid.suffix(12))
        )
        return outputUUID
    }
    
    func getUserByToken(token: String, peripheral: PeripheralModel, keyChain: KeyChainModel) {
        // TokenをもちいてAPIを叩く
        AF.request("https://go-staywatch.kajilab.tk/api/v1/check", method: .get, headers: HTTPHeaders(["Authorization":"Bearer \(token)"]))
            .validate()
            .responseDecodable(of: User.self) {response in
                switch response.result {
                case .success(let user):
                    // API通信成功時の処理
                    // 現在時刻の取得
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                    self.latestSyncTime = dateFormatter.string(from: currentDate)
                    // ユーザ情報
                    self.uuid = self.convertToUUIDFormat(rawUuid: user.uuid)
                    self.userName = user.name
                    self.communityName = user.communityName
                    // UserDefaultsへ保存
                    UserDefaults.standard.set(self.uuid, forKey: "uuid")
                    UserDefaults.standard.set(self.communityName, forKey: "communityName")
                    UserDefaults.standard.set(self.userName, forKey: "userName")
                    UserDefaults.standard.set(self.latestSyncTime, forKey:"latestSyncTime")
                    peripheral.serviceUUIDStr = self.uuid
                    peripheral.stopAdvertising()
                    peripheral.startAdvertisingWithOption()
                case .failure(let error):
                    // API通信失敗時の処理
                    print(error)
                    // サインインし直す
                    self.googleAuth(peripheral: peripheral, keyChainModel: keyChain)
                }
            }
    }
    
    func googleAuth(peripheral: PeripheralModel, keyChainModel: KeyChainModel) {
        // トークンの取得、保存、アドバタイズ開始までやる
        guard let clientID:String = FirebaseApp.app()?.options.clientID else { return }
        let config:GIDConfiguration = GIDConfiguration(clientID: clientID)
        
        let windowScene:UIWindowScene? = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootViewController:UIViewController? = windowScene?.windows.first!.rootViewController!
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController!) { result, error in
            guard error == nil else {
                print("GIDSignInError: \(error!.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
            self.login(credential: credential, peripheral: peripheral, keyChainModel: keyChainModel)
        }
    }
    
    func login(credential: AuthCredential, peripheral: PeripheralModel, keyChainModel: KeyChainModel) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                // サインイン失敗時の処理
                print("SignInError: \(error.localizedDescription)")
                return
            }else {
                // サインイン成功時の処理
                let firebaseUser = Auth.auth().currentUser
                guard let firebaseUser = firebaseUser else {
                    print("firebaseUserがnilです")
                    return
                }
                
                self.email = firebaseUser.email!
                UserDefaults.standard.set(self.email, forKey: "email")
                
                // バックエンドからユーザ情報を取得する
                firebaseUser.getIDTokenForcingRefresh(true) { idToken, _ in
                    guard let _ = idToken else {
                        // Handle error
                        print("トークンの取得に失敗")
                        return;
                    }
                    guard let idToken = idToken else {
                        print("トークンがnil")
                        return
                    }
                    
                    // トークン取得成功時の処理
                    do {
                        try keyChainModel.save(token: idToken)
                    }
                    catch {
                        print(error)
                    }
                    
                    self.getUserByToken(token: idToken, peripheral: peripheral, keyChain: keyChainModel)
                }
            }
        }
    }
}
