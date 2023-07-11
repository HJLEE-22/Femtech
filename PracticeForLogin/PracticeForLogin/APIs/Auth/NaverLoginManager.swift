//
//  NaverLoginManager.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/07/07.
//

import Foundation
import NaverThirdPartyLogin
import Alamofire

final class NaverLoginManager: NSObject {
    
    // MARK: - Properties
    static let shared: NaverLoginManager = NaverLoginManager()
    private override init() {}
    
    //네이버 로그인 인스턴스
    private let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    //네이버 로그인 API로 유저 데이터 페치 성공시 처리
    private var success: ((_ loginData: NaverLoginModel) -> Void)? = { loginData in
        UserDefaults.standard.setValue(loginData.response.email, forKey: UserDefaultsKey.userEmail)
        UserDefaults.standard.setValue(loginData.response.name, forKey: UserDefaultsKey.userName)
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.isUserExists)
        if let viewController = UIApplication.topViewController() {
            viewController.present(MainTabBarController(), animated: false)
        }
    }
    //네이버 로그인 API로 유저 데이터 페치 실패시 처리
    private var failure: ((_ error: AFError) -> Void)? = { error in
        print(error.localizedDescription)
        if let viewController = UIApplication.topViewController(base: nil) {
            viewController.showAlert("네이버 유저 데이터 로드 실패", "이유: \(String(error.localizedDescription))\n문제가 반복된다면 관리자에게 문의하세요.", nil)
        }
    }
    // MARK: - Helpers
    // 사용자 정보를 받아오기 전에 토큰 체크
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
    
    //로그인 한다.
    func logIn() {
        instance?.delegate = self
        instance?.requestThirdPartyLogin()
    }
    
    //토큰을 갱신한다.
    private func refreshToken() {
        self.instance?.delegate = self
        self.instance?.requestAccessTokenWithRefreshToken()
    }
    
    //로그아웃한다.
    func logOut() {
        self.instance?.delegate = self
        self.instance?.resetToken()
        //앱에 저장된 사용자 정보 삭제 필요
    }
    
    //네이버 로그인 서비스 연결을 해지한다.
    func disconnect() {
        self.instance?.delegate = self
        self.instance?.requestDeleteToken()
        //앱에 저장된 사용자 정보 삭제 필요
    }
    
    //사용자 정보를 받아온다.
    private func fetchUserData() {
        guard let tokenType = instance?.tokenType else { return }
        guard let accessToken = instance?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseDecodable(of: NaverLoginModel.self) { [self] response in
            print(response)
            print(response.result)
            
            switch response.result {
            case .success(let loginData):
                print(loginData.resultCode)
                print(loginData.message)
                print(loginData.response)
                if let success = self.success {
                    success(loginData)
                }
                break
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                if let failure = self.failure {
                    failure(error)
                }
                break
            }
        }
    }
}


//MARK: - Naver Login Delegate
extension NaverLoginManager: NaverThirdPartyLoginConnectionDelegate {
    // 로그인에 성공한 경우 호출 됨
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공")
        self.getInfo()
        if let viewController = UIApplication.topViewController() {
            viewController.present(MainTabBarController(), animated: false)
        }
    }
    // 토큰 갱신 성공 시 호출 됨
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 토큰 갱신 성공")
        self.getInfo()
        if let viewController = UIApplication.topViewController() {
            viewController.present(MainTabBarController(), animated: false)
        }
    }
    // 연동해제 성공한 경우 호출 됨
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 연동 해제 성공")
    }
    // 모든 error인 경우 호출 됨
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        //topViewController를 구해서, 있으면 alert을 띄움
        if let viewController = UIApplication.topViewController(base: nil) {
            viewController.showAlert("네이버 SNS 로그인 실패", "이유: \(String(error.localizedDescription))\n문제가 반복된다면 관리자에게 문의하세요.", nil)
        }
    }
    
}
