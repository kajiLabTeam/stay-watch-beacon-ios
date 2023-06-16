//
//  Chart.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/06/16.
//

import SwiftUI
import Charts

struct PointsData: Identifiable {
    // 点群データの構造体
    
    var xValue: Int
    var yValue: Int
    var id = UUID()
}

struct ChartView: View {
    var y: [Int]
    
    // データを定義
    @State var data: [PointsData] = [
        .init(xValue: 0, yValue: 5),
        .init(xValue: 1, yValue: 4)
    ]
    
    @State var plotRange = 30   // 範囲を変えたいときはここと
    
    
    var body: some View {
        VStack{
            Chart {
                ForEach(y.indices, id: \.self) { index in
                    // 折れ線グラフをプロット
                    let xValue = index
                    let yValue = y[index]
                    
                    LineMark(
                        x: .value("x", xValue),
                        y: .value("y", yValue)
                    )
                }
            }
            .chartXScale(domain: y.count-30 ... y.count)
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(y: [5, 4])
    }
}
