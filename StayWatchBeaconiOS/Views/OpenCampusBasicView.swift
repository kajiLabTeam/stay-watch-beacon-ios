//
//  OpenCampus.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/06/28.
//

import Foundation

import SwiftUI
import CoreBluetooth

// Centralを見るためのContentView
struct OpenCampusBasicView: View {
    
    @StateObject var centralManager = CentralOcBasicManager()
    @StateObject var peripheralManager = PeripheralManager()
    
    var body: some View {
        // graph
        ChartView(y:centralManager.rssis, intervalSec:centralManager.intervalSec)
    }
}


