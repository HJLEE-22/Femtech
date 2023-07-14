//
//  NaverLogInManager.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/07/07.
//

import Foundation
import NaverThirdPartyLogin
import Alamofire

final class NaverLogInManager: NSObject {
    
    // MARK: - Properties
    static let shared = NaverLogInManager()
    private override init() {}
    
    //네이버 로그인 인스턴스
    private let instance = NaverThirdPartyLoginConnection.getSharedInstance()

    // MARK: - Helpers
    // 사용자 정보를 받아오기 전에 토큰 체크
    // 네이버 로그인 토큰을 관리하지 않을 순 없음. 토큰이 만료되면 일단 네이버 로그인의 인증이 불가할 것.
    private func getInfo() {
        guard let isValidAccessToken = instance?.isValidAccessTokenExpireTimeNow() else {
            //로그인이 성공으로 떴는데 안됐을 경우 다시 시도?
            self.logIn()
            return
        }
        if !isValidAccessToken {
            //접근 토큰 갱신 필요
            self.refreshToken()
            return
        } else {
            self.fetchUserData()
        }
    }
    
    func logIn() {
        instance?.delegate = self
        instance?.requestThirdPartyLogin()
    }
    
    private func refreshToken() {
        self.instance?.delegate = self
        self.instance?.requestAccessTokenWithRefreshToken()
    }
    
    func logOut() {
        self.instance?.delegate = self
        self.instance?.resetToken()
        //앱에 저장된 사용자 정보 삭제 필요
    }
    
    // 로그아웃 말고 네이버 로그인 서비스 연결을 해지
    func signOut() {
        self.instance?.delegate = self
        self.instance?.requestDeleteToken()
//        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.refreshToken)
        //앱에 저장된 사용자 정보 삭제 필요
    }
    
    //사용자 정보를 받아온다.
    private func fetchUserData() {
        guard let tokenType = instance?.tokenType else { return }
        guard let accessToken = instance?.accessToken else { return }
        let urlStr = NetworkNames.naverLoginApi
        let url = URL(string: urlStr)
        let authorization = "\(tokenType) \(accessToken)"
        guard let url else {
            print("DEBUG: Naver login url error")
            return
        }
        let req = AF.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: JSONEncoding.default,
                             headers: ["Authorization": authorization])
        
        req.responseDecodable(of: NaverLoginModel.self) { response in
            print("DEBUG: response", response)
            print("DEBUG: result", response.result)
            
            switch response.result {
            case .success(let loginData):
                print("DEBUG: resultCode", loginData.resultCode)
                print("DEBUG: message", loginData.message)
                print("DEBUG: loginData-response", loginData.response)

                let email = loginData.response.email
                let userName = loginData.response.name

                if let refreshToken = UserDefaults.standard.string(forKey: UserDefaultsKey.refreshTokenForNaver) {
                    NetworkLogInManager.shared.fetchUserLogIn(email: email,
                                                              userName: userName,
                                                              refreshToken: refreshToken,
                                                              logInType: .naver)
                } else {
                    NetworkLogInManager.shared.fetchUserSignUp(email: loginData.response.email,
                                                               userName: loginData.response.name,
                                                               logInType: .naver)
                    // NetworkLoginManager 에서도 실행하지만, 우선 refreshToken 문제로 인해 여기서 실행. 차후 삭제할 것.
                    UserDefaults.standard.setValue(userName, forKey: UserDefaultsKey.userName)
                    UserDefaults.standard.setValue(email, forKey: UserDefaultsKey.userEmail)
                    UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.isUserExists)
                    UserDefaults.standard.setValue(LogInType.naver.rawValue, forKey: UserDefaultsKey.loginCase)
                }
                break
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                    if let viewController = UIApplication.topViewController(base: nil) {
                        viewController.showAlert("네이버 유저 데이터 로드 실패", "이유: \(String(error.localizedDescription))\n문제가 반복된다면 관리자에게 문의하세요.", nil)
                    }
                break
            }
        }
    }
}


//MARK: - Naver Login Delegate
extension NaverLogInManager: NaverThirdPartyLoginConnectionDelegate {
    // 로그인에 성공한 경우 호출 됨
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공")
        self.getInfo()
//        if let viewController = UIApplication.topViewController() {
//            viewController.present(MainTabBarController(), animated: false)
//        }
    }
    // 토큰 갱신 성공 시 호출 됨
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 토큰 갱신 성공")
        self.getInfo()
//        if let viewController = UIApplication.topViewController() {
//            viewController.present(MainTabBarController(), animated: false)
//        }
    }
    // 연동해제 성공한 경우 호출 됨
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 연동 해제 성공")
        if let viewController = UIApplication.topViewController(base: nil) {
            viewController.showAlert("네이버 연동 해제", "성공적으로 해제되었습니다.", nil)
        }
    }
    // 모든 error인 경우 호출 됨
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        //topViewController를 구해서, 있으면 alert을 띄움
        if let viewController = UIApplication.topViewController(base: nil) {
            viewController.showAlert("네이버 SNS 로그인 실패", "이유: \(String(error.localizedDescription))\n문제가 반복된다면 관리자에게 문의하세요.", nil)
        }
    }
}
