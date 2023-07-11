//
//  AppDelegate.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/22.
//

import UIKit
import FBSDKCoreKit
import NaverThirdPartyLogin
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // facebook login 객체 생성
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // 네이버 로그인 객체 설정
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isNaverAppOauthEnable = true
        instance?.isInAppOauthEnable = true
        
        // 카카오 로그인 객체 설정
        KakaoSDK.initSDK(appKey: "18fe6515c47b24af4f3981b273499a20")

        // 네이버 아이디로 로그인하기 설정
        // NaverThirdPartyConstantsForApp.h 파일이 Define된 kServiceAppUrlScheme, kConsumerKey, kConsumerSecret, kServiceAppName의 수정을 읽지 못해 하드코딩
        instance?.serviceUrlScheme = "com.qstag.femtech"
        instance?.consumerKey = "VeZ2i9qWxPQQr3010AWv"
        instance?.consumerSecret = "iPfzitwwNe"
        instance?.appName = "Femtech"
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    

}

