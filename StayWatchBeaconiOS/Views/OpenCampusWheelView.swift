//
//  OpenCampusWheelView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/06/28.
//

import Foundation

import SwiftUI
import CoreBluetooth

// Centralを見るためのContentView
struct OpenCampusWheelView: View {
    
    @StateObject var centralManager = CentralOcWheelManager()
    
    var body: some View {
        // graph
        ChartDualView(yWheel:centralManager.rssisWheel,yPerson:centralManager.rssisPerson, intervalSec:centralManager.intervalSec)
    }
}
