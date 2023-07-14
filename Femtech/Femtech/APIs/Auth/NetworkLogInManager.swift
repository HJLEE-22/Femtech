//
//  NetworkLogInManager.swift
//  Femtech
//
//  Created by Lee on 2023/07/13.
//

import Foundation
import Alamofire

final class NetworkLogInManager: NSObject {
    
    static let shared = NetworkLogInManager()
    private override init() {}
    
    // 차후 SNS 용은 SignUp/LogIn API 합쳐질 예정
    
    func fetchUserSignUp(email: String, userName: String, logInType: LogInType) {
        // 차후 유저네임이 required/optional 인지 정해지면 오류처리 수정
        let userNameQueried = userName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let parameters = ["com_type": logInType.rawValue, "email": email, "username": userNameQueried]
        let urlString = NetworkNames.devSignUpApi
        print("DEBUG: URLString \(urlString)")
        guard let url = URL(string:urlString) else {
            print("DEBUG: URLString \(urlString)")
            print("DEBUG: incorrect URL for sign up")
            return
        }

        let request = AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
        
        request.validate(statusCode: 200..<300).responseDecodable(of: UserSignUpModel.self) { response in
            switch response.result {
            case .success(let signUpData):
                print("DEBUG: signUpData \(signUpData)")
                guard let refreshToken = signUpData.data.first?.refreshToken else {
                    print("DEBUG: no refresh token")
                    NotificationCenter.default.post(name: Notification.Name.userLogin, object: nil)
                    return
                }
                switch logInType {
                case .kakao:
                    UserDefaults.standard.setValue(refreshToken, forKey: UserDefaultsKey.refreshTokenForKakao)
                case .naver:
                    UserDefaults.standard.setValue(refreshToken, forKey: UserDefaultsKey.refreshTokenForNaver)
                case .google:
                    UserDefaults.standard.setValue(refreshToken, forKey: UserDefaultsKey.refreshTokenForGoogle)
                default:
                    break
                }
                UserDefaults.standard.setValue(email, forKey: UserDefaultsKey.userEmail)
                UserDefaults.standard.setValue(userName, forKey: UserDefaultsKey.userName)
                UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.isUserExists)
                NotificationCenter.default.post(name: Notification.Name.userLogin, object: nil)
                // 회원가입 후 바로 로그인 상태로 전환. 회원가입 시에도 리프레시 토큰 나올 것.
//                self?.fetchUserLogIn(email: email, userName: userName, refreshToken: refreshToken, logInType: .kakao)
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                UserDefaults.standard.setValue(false, forKey: UserDefaultsKey.isUserExists)
            }
        }
    }
    
    // 미완성. API 업데이트 되면 보완.
    func fetchUserLogIn(email: String, userName: String, refreshToken: String, logInType: LogInType) {
        // 차후 유저네임이 required/optional 인지 정해지면 오류처리 수정
        let userName = userName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "noUserName"
        
        let parameters = ["com_type": logInType.rawValue, "email": email, "username": userName, "REFRESH_TOKEN": refreshToken]
        let urlString = NetworkNames.devLogInApi
        guard let url = URL(string:urlString) else {
            print("DEBUG: incorrect URL for log in")
            return
        }
        let request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        request.responseDecodable(of: UserLogInModel.self) { response in
            switch response.result {
            case .success(let logInData):
                print("DEBUG: final logInData \(logInData)")
                UserDefaults.standard.setValue(logInData.data.first?.email, forKey: UserDefaultsKey.userEmail)
                UserDefaults.standard.setValue(userName, forKey: UserDefaultsKey.userName)
                UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.isUserExists)
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                UserDefaults.standard.setValue(false, forKey: UserDefaultsKey.isUserExists)
            }
        }
    }
}
