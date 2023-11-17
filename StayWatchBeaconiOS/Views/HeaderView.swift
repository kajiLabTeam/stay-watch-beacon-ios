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
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            HStack {
                //Text(firebaseController.communityName)
                Text(user.email)
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()
                VStack {
                    Button(action: {
                        //                                firebaseController.googleAuth(peripheral: peripheralManager, tokenStorage: tokenStorage)
                        viewController.signIn(firebaseAuth: firebaseAuth, peripheral: peripheral, keyChain: keyChain)
                    }) {
                        Text("別のアカウントで\nサインイン")
                            .font(.caption)
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .border(Color.yellow, width:3.0)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            //.foregroundColor(Color.black)
                    }
                    //Text(firebaseController.email)
//                    Text(user.email)
//                        .font(.caption)
                }
            }
            .padding(.horizontal, 5)
            Divider()
        }
    }
}
