//
//  FirebaseAuthController.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/07/05.
//

import Foundation
import SwiftUI

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

class FirebaseAuthController: NSObject, ObservableObject{
    
    @Published var email = ""
    @Published var communityName = "noen"
    @Published var userName = "none"
    @Published var uuid = ""
    
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
    
    func getUserByToken(token: String, peripheral: PeripheralManager) {
        // TokenをもちいてAPIを叩く
        AF.request("https://go-staywatch.kajilab.tk/api/v1/check", method: .get, headers: HTTPHeaders(["Authorization":"Bearer \(token)"]))
        //AF.request("http://192.168.101.8:8082/api/v1/check", method: .get, headers: HTTPHeaders(["Authorization":"Bearer \(token)"]))   // ローカル
            .validate()
            .responseDecodable(of: User.self) {response in
                switch response.result {
                case .success(let user):
                    // API通信成功時の処理
                    print("API通信成功だドン！！")
                    print(user)
                    self.uuid = self.convertToUUIDFormat(rawUuid: user.uuid)
                    print("フォーマット後のUUIDは \(self.uuid)")
                    self.userName = user.name
                    self.communityName = user.communityName
                    UserDefaults.standard.set(self.uuid, forKey: "uuid")
                    UserDefaults.standard.set(self.communityName, forKey: "communityName")
                    UserDefaults.standard.set(self.userName, forKey: "userName")
                    peripheral.serviceUUIDStr = self.uuid
                    peripheral.stopAdvertising()
                    peripheral.startAdvertisingWithOption()
                    
                    print("UserDefaultsの中身")
                    print(UserDefaults.standard.string(forKey: "uuid"))
                    print(UserDefaults.standard.string(forKey: "communityName"))
                    print(UserDefaults.standard.string(forKey: "userName"))
                case .failure(let error):
                    // API通信失敗時の処理
                    print("API通信失敗だドン。。。。。")
                    print(error)
                }
            }
    }
    
    func googleAuth(peripheral: PeripheralManager, tokenStorage: TokenStorage) {
        //var firebaseController:PeripheralManager
        
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
            self.login(credential: credential, peripheral: peripheral, tokenStorage: tokenStorage)
        }
    }
    
    func login(credential: AuthCredential, peripheral: PeripheralManager, tokenStorage: TokenStorage) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("サインイン失敗だドン。。。")
                print("SignInError: \(error.localizedDescription)")
                return
            }else {
                print("サインイン成功だどん！")
                let firebaseUser = Auth.auth().currentUser
                guard let firebaseUser = firebaseUser else {
                    print("firebaseUserがnilです")
                    return
                }
//                guard let firebaseUserEmail = firebaseUser.email else {
//                    print("firebaseUserのemailがnilです")
//                    return
//                }
                print(firebaseUser)
                self.email = firebaseUser.email!
                UserDefaults.standard.set(self.email, forKey: "email")
                //                let photoURL = firebaseUser.photoURL
                //                let uid = firebaseUser.uid
                
                
                // バックエンドからユーザ情報を取得する
                firebaseUser.getIDTokenForcingRefresh(true) { idToken, _ in
                    guard let _ = idToken else {
                        // Handle error
                        print("トークンの取得に失敗だドン。。。")
                        return;
                    }
                    guard let idToken = idToken else {
                        print("idTokenがnilです")
                        return
                    }
                    print("トークンの取得成功だドン！")
                    print(idToken)
                    
                    do {
                        try tokenStorage.save(token: idToken)
                    }
                    catch {
                        print(error)
                    }
                    self.getUserByToken(token: idToken, peripheral: peripheral)
                }
            }
        }
    }
}
