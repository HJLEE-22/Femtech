//
//  FacebookLoginManager.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/07/07.
//

import Foundation
import FBSDKLoginKit

final class FacebookLoginManager: NSObject {
    
    static let shared = FacebookLoginManager()
    private override init() {}

    func logInWithFacebook() {
//        guard let window = self.view.window else { return }
        if let token = AccessToken.current,
           !token.isExpired {
            // 로그인 되어있는 경우
            guard AccessToken.current != nil,
                  let accessToken: String = AccessToken.current?.tokenString as? String else {
                    print("DEBUG: no accessToken by facebook login")
                    return
            }
            print("DEBUG: accessToken by facebook login \(accessToken)")
        } else {
            // 로그인 요청
            let fbInstance = FBLoginButton()
            fbInstance.delegate = self
            fbInstance.permissions = ["public_profile", "email"]
            fbInstance.sendActions(for: .touchUpInside)
        }
    }
}


// MARK: - facebook login delegate
extension FacebookLoginManager: LoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            //self.delegate?.onError(.facebook, error)
            print("DEBUG: \(error)")
        } else {
            if let result = result {
                let callback = "window.setAccessToken"
                guard AccessToken.current != nil,
                      let accessToken: String = AccessToken.current?.tokenString as? String else {
                    return
                }
                // 로그인 완료 후 처리사항
                UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.isUserExists)
//                UserDefaults.standard.setValue(fullName, forKey: UserDefaultsKey.userName)
//                UserDefaults.standard.setValue(email, forKey: UserDefaultsKey.userEmail)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        // 페이스북 싱글톤으로 로그아웃 완료된 후 우리 서버의 token 등 탈퇴 처리.
    }

}
