//
//  BackgroundManager.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/06/12.
//

import Foundation
import BackgroundTasks

class BackgroundManager: ObservableObject {
    
    var allUpdateRequests: [BGTaskRequest] = []
    
    init() {
        allUpdateRequests = []
        print("初期化(Background)")
    }
    
    func createSchedule(){
        if let scheduledTime = Calendar.current.date(byAdding: .second, value: 10, to: Date()) {
            print("createScheduleが実行されたよ")
            let request = BGAppRefreshTaskRequest(identifier: "com.togawakouta.StayWatchBeaconiOS.appRefresh")
            request.earliestBeginDate = scheduledTime
            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("createScheduleが失敗したよ")
                // Handle errors here...
            }
        }
    }

    func getTasks(){
        BGTaskScheduler.shared.getPendingTaskRequests { requests in
            DispatchQueue.main.async {
                self.allUpdateRequests = requests
                print("getTaskだよ")
                print(self.allUpdateRequests)
            }
        }
    }
    
}
