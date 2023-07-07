//
//  AppleSignInManager.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/07/05.
//

import UIKit
import AuthenticationServices

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
}

// apple 로그인 성공 후 처리 내역
extension AppleSignInManager: ASAuthorizationControllerDelegate {
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
        UserDefaults.standard.set(userIdentifier, forKey: UserDefaultsKey.AppleUserIdentifier)
//        UserDefaults.standard.setValue(fullName, forKey: UserDefaultsKey.UserName)
//        UserDefaults.standard.setValue(email, forKey: UserDefaultsKey.UserEmail)
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.UserExists)
        
        self.tokenSignIn(idToken: identityToken)
    }
    
    // 개발 서버에 토큰 전달
    
    func tokenSignIn(idToken: Data?) {
        guard let data = idToken else {
            print("DEBUG: No ID token for apple login")
            return
        }
        let url = URL(string: "https://yourbackend.example.com/tokensignin")!
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
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}
// 애플로그인 윈도우창
extension AppleSignInManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window ?? UIWindow()
    }
}

