//
//  ContentView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/05/18.
//

import SwiftUI
import CoreBluetooth

// Centralを見るためのContentView
struct ContentView: View {
    
    var body: some View {
        
        BeaconView(viewController: BeaconViewController())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
