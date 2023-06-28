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

// Centralを見るためのContentView
struct SigninView: View {
    
    @StateObject var signinManager = TestSigninManager()
    @State var userEmail = ""
    @State var userId = ""
    
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
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    let email = user.email
                    let photoURL = user.photoURL
                    print("uid: \(uid)")
                    print(email)
                    print(photoURL)
                    userId = uid
                    userEmail = email!
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
        }
    }
}


struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}

