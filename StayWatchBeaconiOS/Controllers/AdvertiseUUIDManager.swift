//
//  AdvertiseUUIDManager.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/07/27.
//

import Foundation
import CoreBluetooth
class AdvertiseUUIDManager: NSObject, ObservableObject{
    // 12 -> [4, 8]
    func divideIntoPowersOfTwo(inputNum: Int) -> [Int] {
        var powers = [Int]()
        var currentPower = 1
        var num = inputNum
        
        while num > 0 {
            if num % 2 == 1 {
                powers.append(currentPower)
            }
            currentPower *= 2
            num = num / 2
        }
        
        return powers
    }
    
    func replaceCharacter(index: Int, newCharacter: Character, inputString: String) -> String {
        var characters = Array(inputString)
        
        if index < characters.count {
            characters[index] = newCharacter
        }
        
        return String(characters)
    }
    
    
    func generateAdvertisingUUIDs(inputUUID: String) -> [CBUUID] {
        let maps = ManufacturerUUIDMap()
        print(inputUUID)            // 8ebc2114-4abd-0000-0000-ff010000009c
        print(inputUUID.suffix(5))  // 0009c
        var dividedUUIDIndex = 0
        var advertiseUUIDs = [CBUUID]()
        advertiseUUIDs.append(CBUUID(string: "00000000-0000-0000-0000-0000000000" + maps.eights[0]))    // 感知中か否かを受信機からわかるようにするため
        for currentUUIDCharacter in inputUUID.suffix(5){
            //            print("forの中")
            //            print(currentUUIDCharacter)
            let number = Int(String(currentUUIDCharacter), radix: 16)
            let devidedUUIDNumbers = divideIntoPowersOfTwo(inputNum: number!) // 例：[1,8]
            //print(devidedUUIDNumbers)
            for devidedUUIDNumber in devidedUUIDNumbers {
                //print("for j の中")
                //print(devidedUUIDNumber)
                for k in 0...4{
                    let numIndex = 3+dividedUUIDIndex+(6*k)
                    var advertisingManufacturer = replaceCharacter(index: numIndex+6, newCharacter: Character(String(devidedUUIDNumber)), inputString: "4c000100000000000000000000000000000000")
                    var advertiseUUID = "00000000-0000-0000-0000-0000000000"
                    switch devidedUUIDNumber {
                    case 1:
                        advertiseUUID = advertiseUUID + maps.ones[numIndex]
                    case 2:
                        //print("2が" + String(numIndex))
                        advertiseUUID = advertiseUUID + maps.twos[numIndex]
                    case 4:
                        //print("4が" + String(numIndex))
                        advertiseUUID = advertiseUUID + maps.fours[numIndex]
                    case 8:
                        //print("8が" + String(numIndex))
                        advertiseUUID = advertiseUUID + maps.eights[numIndex]
                    default:
                        print("error")
                    }
                    print(advertiseUUID)
                    advertiseUUIDs.append(CBUUID(string:advertiseUUID))
                }
            }
            dividedUUIDIndex = dividedUUIDIndex + 1
        }
        print(advertiseUUIDs)
        return advertiseUUIDs
    }
}
