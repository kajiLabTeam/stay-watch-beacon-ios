//
//  User.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/07/11.
//

import Foundation

class UserUtil: NSObject, ObservableObject {
    
    var name: String {
        get{
            // UserDefaultsのuserNameが存在しなければ空の文字列を渡す
            guard let out = UserDefaults.standard.string(forKey: "userName") else {
                return ""
            }
            
            return out
        }
    }
    
    var uuid: String {
        get{
            guard let out = UserDefaults.standard.string(forKey: "uuid") else {
                return "00000000-0000-0000-0000-000000000000"
            }
            return out
        }
    }
    
    var email: String {
        get{
            guard let out = UserDefaults.standard.string(forKey: "email") else {
                return ""
            }
            return out
        }
    }
    
    var communityName: String {
        get{
            guard let out = UserDefaults.standard.string(forKey: "communityName") else {
                return ""
            }
            return out
        }
    }
    
    var latestSyncTime: String {
        get{
            guard let out = UserDefaults.standard.string(forKey: "latestSyncTime") else {
                return ""
            }
            return out
        }
    }
}
