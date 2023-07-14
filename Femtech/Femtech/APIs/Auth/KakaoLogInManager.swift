//
//  KakaoLogInManager.swift
//  Femtech
//
//  Created by Lee on 2023/07/13.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import Alamofire

final class KakaoLogInManager: NSObject {
    
    static let shared = KakaoLogInManager()
    private override init() {}
    
    func logInWithKakao() {
        // kakaotalk이 설치되어 있을 경우
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                guard error == nil else {
                    print("DEBUG: \(error!)")
                    // 카카오톡이 설치되어 있지만 로그인되지 않은 경우 에러 발생 가능성 존재
                    return
                }
                self?.setUserInfoByKakao()
            }
        } else {
            // kakaotalk이 설치되어있지 않은 경우 openSafariApi로 연결해 진행
            UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
                guard error == nil else {
                    print("DEBUG: \(error!)")
                    return
                }
                self?.setUserInfoByKakao()
                return
            }
        }
    }
    
    private func setUserInfoByKakao() {
        UserApi.shared.me { user, error in
            guard let email = user?.kakaoAccount?.email,
                  let name = user?.kakaoAccount?.profile?.nickname else {
                print("DEBUG: kakao email/nickname 없음")
                return
            }
            // 수신한 email 서버에 전달
            print("DEBUG: kakao email \(email)")
            if let refreshToken = UserDefaults.standard.string(forKey: UserDefaultsKey.refreshTokenForKakao) {
                print("DEBUG: refreshToken for Kakao exists \(refreshToken)")
                NetworkLogInManager.shared.fetchUserLogIn(email: email,
                                                          userName: name,
                                                          refreshToken: refreshToken,
                                                          logInType: .kakao)
            } else {
                NetworkLogInManager.shared.fetchUserSignUp(email: email,
                                                           userName: name,
                                                           logInType: .kakao)
            }
            // NetworkLoginManager 에서도 실행하지만, 우선 refreshToken 문제로 인해 여기서 실행. 차후 삭제할 것.
            UserDefaults.standard.setValue(name, forKey: UserDefaultsKey.userName)
            UserDefaults.standard.setValue(email, forKey: UserDefaultsKey.userEmail)
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.isUserExists)
            UserDefaults.standard.setValue(LogInType.kakao.rawValue, forKey: UserDefaultsKey.loginCase)
        }
    }
}

