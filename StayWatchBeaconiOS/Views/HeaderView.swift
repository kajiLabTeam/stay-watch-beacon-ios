//
//  HeaderView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/08/01.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    @StateObject var viewController: BeaconViewController
    @StateObject var firebaseAuth: FirebaseAuthenticationModel
    @StateObject var peripheral: PeripheralModel
    @StateObject var keyChain: KeyChainModel
    @ObservedObject var user: UserUtil
    
    var body: some View {
        VStack {
            HStack {
                //Text(firebaseController.communityName)
                Text(user.communityName)
                    .font(.title3)
                    .fontWeight(.medium)
                Spacer()
                VStack {
                    Button(action: {
                        //                                firebaseController.googleAuth(peripheral: peripheralManager, tokenStorage: tokenStorage)
                        viewController.signIn(firebaseAuth: firebaseAuth, peripheral: peripheral, keyChain: keyChain)
                    }) {
                        Text("別のアカウントでサインイン")
                            .font(.caption)
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .border(Color.yellow, width:3.0)
                            .foregroundColor(Color.black)
                    }
                    //Text(firebaseController.email)
                    Text(user.email)
                        .font(.caption)
                }
            }
            .padding(.horizontal, 5)
            Divider()
        }
    }
}
