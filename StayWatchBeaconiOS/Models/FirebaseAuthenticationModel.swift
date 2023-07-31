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

//struct User: Codable {
//    let id: Int
//    let role: Int
//    let uuid: String
//    let name: String
//    let communityId: Int
//    let communityName: String
//}

class FirebaseAuthenticationModel: NSObject, ObservableObject{
    
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
    
    func getUserByToken(token: String, peripheral: PeripheralModel) -> String? {
        var result:String? = nil
        // TokenをもちいてAPIを叩く
        AF.request("https://go-staywatch.kajilab.tk/api/v1/check", method: .get, headers: HTTPHeaders(["Authorization":"Bearer \(token)"]))
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
                    result = error.localizedDescription
                }
            }
        return result
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
                
                print(firebaseUser)
                self.email = firebaseUser.email!
                UserDefaults.standard.set(self.email, forKey: "email")
                
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
                        try keyChainModel.save(token: idToken)
                    }
                    catch {
                        print(error)
                    }
                    
                    guard let err = self.getUserByToken(token: idToken, peripheral: peripheral) else {
                        print("トークンからユーザ情報の取得に失敗")
                        return
                    }
                }
            }
        }
    }
}
