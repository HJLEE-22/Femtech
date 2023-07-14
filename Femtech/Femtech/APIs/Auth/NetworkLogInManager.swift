//
//  SignUpManager.swift
//  Femtech
//
//  Created by Lee on 2023/07/13.
//

import Foundation
import Alamofire

final class NetworkLogInManager: NSObject {
    
    static let signUpManager = NetworkLogInManager()
    private override init() {}
    
    func fetchUserSignUp(email: String, userName: String, logInType: LogInType) {
        
        let userName = userName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "noUserName"
        let parameters = ["com_type": logInType.rawValue, "email": email, "username": userName]

        let urlString = "http://3.34.137.105:8080/api/signup/?"
        print("DEBUG: URLString \(urlString)")
        guard let url = URL(string:urlString) else {
            print("DEBUG: URLString \(urlString)")
            print("DEBUG: no url...")
            return
        }
        let request = AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
        
        request.validate(statusCode: 200..<300).responseDecodable(of: UserSignUpModel.self) { [weak self] response in
            switch response.result {
            case .success(let signUpData):
                print("DEBUG: signUpData \(signUpData)")
                guard let refreshToken = signUpData.data.first?.refreshToken else {
                    print("DEBUG: no refresh token")
                    return
                }
//                let refreshToken = signUpData.data.refreshToken
                UserDefaults.standard.setValue(refreshToken, forKey: UserDefaultsKey.refreshTokenForKakao)
                self?.fetchUserLogIn(email: email, userName: userName, refreshToken: refreshToken, logInType: .kakao)
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                UserDefaults.standard.setValue(false, forKey: UserDefaultsKey.isUserExists)
            }
        }
    }
    
    func fetchUserLogIn(email: String, userName: String, refreshToken: String, logInType: LogInType) {
        let userName = userName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "noUserName"
        let parameters = ["com_type": logInType.rawValue, "email": email, "username": userName, "REFRESH_TOKEN": refreshToken]

        let urlString = "http://3.34.137.105:8080/api/login/?"
        guard let url = URL(string:urlString) else {
            print("DEBUG: no url...2")
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
                if let viewController = UIApplication.topViewController() {
                    viewController.present(MainTabBarController(), animated: false)
                }
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                UserDefaults.standard.setValue(false, forKey: UserDefaultsKey.isUserExists)
            }
        }
    }
    
    
}
