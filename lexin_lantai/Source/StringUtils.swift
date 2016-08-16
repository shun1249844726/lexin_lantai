//
//  StringUtils.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/4/8.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import Foundation
extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    func changeToInt(num:String) -> Int {
        let str = num.uppercaseString
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    func changeToUint8() -> UInt8{
        let str = self.uppercaseString
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return UInt8(sum)
    }
    
}

extension NSData {
    
    // turning NSData into an array of bytes
    var byteArray : [UInt8] {
        
        // create array of appropriate length
        let count = self.length / sizeof(UInt8)
        var array = [UInt8](count: count, repeatedValue: 0)
        
        // copy bytes into array
        self.getBytes(&array, length:count * sizeof(UInt8))
        
        // return the array
        return array
    }
}

func getLongitudeAndLatitude(data:[UInt8]) -> [Double]{
    var longitudeTemp : Int = Int(data[8])*256*256*256
    longitudeTemp +=  Int(data[9])*256*256
    longitudeTemp += Int(data[10])*256
    longitudeTemp += Int(data[11])
    var longitude : Double = Double(longitudeTemp )/1000000
    
    var latitudeTemp : Int =  Int(data[12])*256*256*256
    latitudeTemp += Int(data[13])*256*256
    latitudeTemp += Int(data[14])*256
    latitudeTemp += Int(data[15])
    var latitude : Double = Double(latitudeTemp)/1000000
    
    print("la\(latitude)")
    
    let longitudeZH : Int = Int(longitude)
    let longitudeFN : Double = Double(longitude - Double(longitudeZH)) / 0.6
    
    let latitudeZH : Int = Int(latitude)
    let latitudeFN : Double = Double(latitude - Double(latitudeZH)) / 0.6
    
    
    
    
    longitude = Double(longitudeZH) + longitudeFN
    latitude = Double(latitudeZH) + latitudeFN
    
    
    return [longitude,latitude]
}
