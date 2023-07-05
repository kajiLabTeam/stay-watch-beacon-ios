//
//  SigninView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/06/23.
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

// Centralを見るためのContentView
struct SigninView: View {
    
    @StateObject var signinManager = TestSigninManager()
    @State var userEmail = ""
    @State var userId = ""
    @State var userName = ""
    @State var userUuid = ""
    
    private func googleAuth() {
        
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
            self.login(credential: credential)
        }
    }
    
    private func login(credential: AuthCredential) {
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
                let email = firebaseUser.email
                let photoURL = firebaseUser.photoURL
                let uid = firebaseUser.uid
                print("uid: \(uid)")
                print(email!)
                print(photoURL!)
                userId = uid
                userEmail = email!
                
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
                    // TokenをもちいてAPIを叩く
                    AF.request("https://go-staywatch.kajilab.tk/api/v1/check", method: .get, headers: HTTPHeaders(["Authorization":"Bearer \(idToken)"]))
                    //AF.request("http://192.168.101.8:8082/api/v1/stayers", method: .get, headers: HTTPHeaders(["Authorization":"Bearer \(idToken)"]))
                        .validate()
                        .responseDecodable(of: User.self) {response in
                            switch response.result {
                            case .success(let user):
                                // API通信成功時の処理
                                print("API通信成功だドン！！")
                                print(user)
                                userUuid = user.uuid
                                userName = user.name
                            case .failure(let error):
                                // API通信失敗時の処理
                                print("API通信失敗だドン。。。。。")
                                print(error)
                            }
                        }
                }
            }
        }
    }
    
    var body: some View {
        VStack{
            Text("googleでログインするページ")
            Button(action: {
                googleAuth()
            }) {
                Text("Googleアカウントでサインイン")
            }
            Text("email: \(userEmail)")
            Text("uid: \(userId)")
                .padding(5)
            Text("ユーザ名: \(userName)")
            Text("UUID: \(userUuid)")
        }
    }
}


struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}

