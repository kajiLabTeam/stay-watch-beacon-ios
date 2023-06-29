//
//  ChartDualView.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/06/28.
//

import SwiftUI
import Charts

//struct PointsData: Identifiable {
//    // 点群データの構造体
//
//    var xValue: Double
//    var yValue: Int
//    var id = UUID()
//}

struct ChartDualView: View {
    var yWheel: [Int]
    var yPerson: [Int]
    var intervalSec: Double
    
    // sampleデータを定義
    //    @State var data: [PointsData] = [
    //        .init(xValue: 0, yValue: 5),
    //        .init(xValue: 1, yValue: 4)
    //    ]
    //
    @State var plotRange = 30   // 範囲を変えたいときはここと
    
    
    var body: some View {
        VStack{
            Chart {
                ForEach(yWheel.indices, id: \.self) { index in
                    // 折れ線グラフをプロット
                    let xValue = Double(index) * intervalSec
                    let yValue = yWheel[index]
                    
                    LineMark(
                        x: .value("x", xValue),
                        y: .value("y", yValue)
                    )
                    .foregroundStyle(by: .value("Category", "タイヤ"))
                }
                ForEach(yPerson.indices, id: \.self) { index in
                    // 折れ線グラフをプロット
                    let xValue = Double(index) * intervalSec
                    let yValue = yPerson[index]
                    
                    LineMark(
                        x: .value("x", xValue),
                        y: .value("y", yValue)
                    )
                    .foregroundStyle(by: .value("Category", "介護者"))
                }
            }
            .chartXScale(domain: (Double(yWheel.count) * intervalSec) - Double(plotRange) ... Double(yWheel.count) * intervalSec)
            .chartYScale(domain: -100 ... 0)
            .chartForegroundStyleScale(["タイヤ": .pink, "介護者": .green])
        }
    }
}

//struct ChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChartView(y: [5, 4])
//    }
//}
