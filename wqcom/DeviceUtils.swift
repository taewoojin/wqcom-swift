//
//  DeviceUtils.swift
//  wqcom
//
//  Created by 진태우 on 2017. 9. 6..
//  Copyright © 2017년 jjlee. All rights reserved.
//

class DeviceUtils {
    
    static func getDeviceType() -> String {
        var deviceType: String
        if DeviceType.IS_PAD {
            deviceType = "iphonepad"
        } else if DeviceType.IS_IPHONE_6P {
            deviceType = "iphone6p"
        } else if DeviceType.IS_IPHONE_6 {
            deviceType = "iphone6"
        } else if DeviceType.IS_IPHONE_5 {
            deviceType = "iphone5"
        } else {
            deviceType = "iphone4"
        }
        
        return deviceType
    }
    
//    static func getSystemVersion() -> String {
//        return UIDevice.current.systemVersion
//    }
//    
//    static func getAppVersion() -> String {
//        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
//    }
}
