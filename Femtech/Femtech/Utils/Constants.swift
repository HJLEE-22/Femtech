//
//  Constants.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/27.
//

// 앱 내애서 사용되는 Names와 Keys 관리
import Foundation

public struct SystemNames {
    private init () {}
    static let bundleID = "3F279N36AC.com.qstag.femtech"
}

public struct UserDefaultsKey {
    private init(){}
    
    static let isUserExists = "isUserExists"
    static let userName = "userName"
    static let userEmail = "userEmail"
    static let appleUserIdentifier = "appleUserIdentifier"
    static let loginCase = "loginCase"
    static let refreshTokenForKakao = "refreshTokenForKakao"
    static let refreshTokenForNaver = "refreshTokenForNaver"
    static let refreshTokenForGoogle = "refreshTokenForGoogle"
    static let refreshTokenForFacebook = "refreshTokenForFacebook"
    static let refreshTokenForApple = "refreshTokenForApple"
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
    static let calendarCircle = "calendar.circle"
    static let calendarCircleFill = "calendar.circle.fill"
    static let textAlignLeft = "text.alignleft"
    static let arrowTriangleDownFill = "arrowtriangle.down.fill"
    static let magnifyingGlass = "magnifyingglass"
    static let docCircle = "doc.circle"
    static let docCircleFill = "doc.circle.fill"
}

extension Notification.Name {
    static let userLogin = Notification.Name("userLogin")
}

public struct AnimationNames {
    private init() {}
    
    static let dropPongYellow = "Drop_Pong_yellow" // Launch Screen에서 사용
}
