//
//  Constants.swift
//  wqcom
//
//  Created by 진태우 on 2017. 8. 29..
//  Copyright © 2017년 jjlee. All rights reserved.
//

import Foundation
import UIKit


struct Url {
    
    static let Base                   = "http://10.130.106.16:8080/wqcom/new-blogger"
//    static let Base                   = "http://company.wedqueen.com"
    
    static let Login                    = "\(Base)/login"
    static let Feed                     = "\(Base)/feed"
    static let ContentFeed              = "\(Base)/user/timeline"
    static let WeddingTalk              = "\(Base)/weddingtalk"
    static let CheckList                  = "\(Base)/user/checklist"
    static let PlanBook                 = "\(Base)/user/main"
    static let Noti                     = "\(Base)/noti"
    
}


struct Device {
    static let DeviceType = DeviceUtils.getDeviceType()
//    static let SystemVersion = DeviceUtils.getSystemVersion()
//    static let AppVersion = DeviceUtils.getAppVersion()
}


struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_PAD = UIDevice.current.userInterfaceIdiom == .pad
}

struct Color {
    // #AF9A5E - 골드
    static let Primary          = UIColor(red: 0.68627451, green: 0.60392157, blue: 0.36862745, alpha: 1)
    
    // #EDEDED - 회색
    static let Seperator        = UIColor(red: 0.92941176, green: 0.92941176, blue: 0.92941176, alpha: 1)
}

