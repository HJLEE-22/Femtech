//
//  Constants.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/27.
//

// 앱 내애서 사용되는 Names와 Keys 관리
import Foundation

public struct UserDefaultsKey {
    private init(){}
    
    static let UserExists = "UserExists"
    static let UserName = "UserName"
    static let UserEmail = "UserEmail"
    static let AppleUserIdentifier = "AppleUserIdentifier"
}

public struct IconNames {
    private init() {}
    
    static let customBackButton = "arrowshape.backward"
    static let customTouchedBackButton = "arrowshape.backward.fill"
    static let plusCircleFill = "plus.circle.fill"
    static let house = "house"
    static let houseFill = "house.fill"
    static let gearshape = "gearshape"
    static let gearshapeFill = "gearshape.fill"
    
}

public struct NotificattionNames {
    private init() {}
    
    static let userLogin = Notification.Name("userLogin")
}

public struct NetworkNames {
    private init() {}

    // DEV API 기본 URL (QSCheck)
    static let DEV_API_URL = "https://dev.qsreader.com/api"
    // 음식제안 URL (QSCheck)
    static let FOOD_CATEGORY_URL_DEV = "\(DEV_API_URL)/food?category_id="
}

public struct AnimationNames {
    private init() {}
    
    static let dropPongYellow = "Drop_Pong_yellow" // Launch Screen에서 사용
}
