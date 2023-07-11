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
            return
        }
        let userIdentifier = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        let email = appleIDCredential.email
        let identityToken = appleIDCredential.identityToken
        print("DEBUG: Apple userIdentifier \(userIdentifier)")
        print("DEBUG: Apple fullName \(fullName)")
        print("DEBUG: Apple email \(email)")
        UserDefaults.standard.set(userIdentifier, forKey: UserDefaultsKey.appleUserIdentifier)
//        UserDefaults.standard.setValue(fullName, forKey: UserDefaultsKey.userName)
//        UserDefaults.standard.setValue(email, forKey: UserDefaultsKey.userEmail)
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.isUserExists)
        
        self.tokenSignIn(idToken: identityToken)
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

