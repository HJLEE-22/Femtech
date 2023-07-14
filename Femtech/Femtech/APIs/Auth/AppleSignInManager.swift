//
//  AppleSignInManager.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/07/05.
//

import UIKit
import AuthenticationServices
import Alamofire

final class AppleSignInManager: NSObject {
 
    static let shared = AppleSignInManager()
    private override init() {}
    
    private var window: UIWindow!
    
    func signInWithApple(window: UIWindow) {
        self.window = window
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func signOut() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AppleSignInManager: ASAuthorizationControllerDelegate {
    // apple 로그인 성공 후 처리 내역
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // ASAuthorizationAppleIDCredential은 비밀번호 및 페이스ID 인증
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            // error handling은 밑 메서드에서 진행
            print("DEBUG: no apple id credential")
            return
        }
        let userIdentifier = appleIDCredential.user
//        // appleIDCredential.fullName은 PersonNameComponents 타입. 직접 초기화는 iOS15부터 가능. nil 코얼레싱 값을 주기 위해 givenName으로 작업.
//        let fullName = appleIDCredential.fullName?.givenName ?? "no name"
        let givenName = appleIDCredential.fullName?.givenName ?? "이름"
        let familyName = appleIDCredential.fullName?.familyName ?? "성"
        let fullName  = "\(familyName)\(givenName)"
        let email = appleIDCredential.email ?? "no email"
        let identityToken = appleIDCredential.identityToken
        print("DEBUG: Apple userIdentifier \(userIdentifier)")
        print("DEBUG: Apple fullName \(fullName)")
        print("DEBUG: Apple email \(email)")
        UserDefaults.standard.set(userIdentifier, forKey: UserDefaultsKey.appleUserIdentifier)
        UserDefaults.standard.setValue(fullName, forKey: UserDefaultsKey.userName)
        UserDefaults.standard.setValue(email, forKey: UserDefaultsKey.userEmail)
//        if let viewController = UIApplication.topViewController() {
//            viewController.present(MainTabBarController(), animated: false)
//        }
        
        self.tokenSignIn(idToken: identityToken)
        self.fetchUserSignUp(idToken: identityToken, logInType: .apple)
    }
    
    // 개발 서버에 토큰 전달
    func tokenSignIn(idToken: Data?) {
        guard let data = idToken else {
            print("DEBUG: No ID token for apple login")
            return
        }
        guard let url = URL(string: "https://yourbackend.example.com/tokensignin") else {
            print("DEBUG: apple sign in url error / https://yourbackend.example.com/tokensignin")
            return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
            // Handle response from your backend.
        }
        task.resume()
    }
    
    func fetchUserSignUp(idToken: Data?, logInType: LogInType) {
        // 차후 유저네임이 required/optional 인지 정해지면 오류처리 수정
        let idTokenString = idToken?.base64EncodedString() ?? "noAccessCode"
        
        let parameters = ["com_type": logInType.rawValue, "access_code": idTokenString]
        let urlString = NetworkNames.devSignUpApi
        guard let url = URL(string:urlString) else {
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
                UserDefaults.standard.setValue(refreshToken, forKey: UserDefaultsKey.refreshTokenForApple)
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
    
    /*
     // token을 String화 해 딕셔너리로 전달 방식
    func tokenSignIn(idToken: String) {
        guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else {
            return
        }
        let url = URL(string: "https://yourbackend.example.com/tokensignin")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            // Handle response from your backend.
        }
        task.resume()
    }
    */
    
    /*
     // 회원탈퇴 시 token revoke 필수
    func revokeAppleToken(clientSecret: String, token: String, completionHandler: @escaping () -> Void) {
        let url = "https://appleid.apple.com/auth/revoke?client_id=YOUR_BUNDLE_ID&client_secret=\(clientSecret)&token=\(token)&token_type_hint=refresh_token"
        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        AF.request(url,
                   method: .post,
                   headers: header)
        .validate(statusCode: 200..<600)
        .responseData { response in
            guard let statusCode = response.response?.statusCode else { return }
            if statusCode == 200 {
                print("애플 토큰 삭제 성공!")
                completionHandler()
            }
        }
    }
     */
    
    // MARK: - 애플 엑세스 토큰 발급 응답 모델
    struct AppleTokenResponse: Codable {
        var access_token: String?
        var token_type: String?
        var expires_in: Int?
        var refresh_token: String?
        var id_token: String?

        enum CodingKeys: String, CodingKey {
            case refresh_token = "refresh_token"
        }
    }
    
    // MARK: - Error 발생

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}
// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AppleSignInManager: ASAuthorizationControllerPresentationContextProviding {
    // 애플로그인 윈도우창
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window ?? UIWindow()
    }
}

