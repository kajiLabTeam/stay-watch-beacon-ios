//
//  SigninView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/08/01.
//

import Foundation
import SwiftUI

struct SigninView: View {
    @StateObject var viewController: BeaconViewController
    @StateObject var firebaseAuth: FirebaseAuthenticationModel
    @StateObject var peripheral: PeripheralModel
    @StateObject var keyChain: KeyChainModel
    
    var body: some View {
        VStack {
            Spacer()
            Group{
                Text("滞在ウォッチ用ビーコン")
                Text("for iOS")
            }
            .font(.title)
            Spacer()
            Button(action: {
                viewController.signIn(firebaseAuth: firebaseAuth, peripheral: peripheral, keyChain: keyChain)
            }) {
                Text("Googleアカウントでサインイン")
                    .padding()
                    .foregroundColor(Color.black)
                    .font(.title2)
                    .background(Color.yellow)
                    .cornerRadius(10)
            }
            Spacer()
        }
    }
}
