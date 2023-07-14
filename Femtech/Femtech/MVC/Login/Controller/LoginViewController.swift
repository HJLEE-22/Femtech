//
//  LgoinViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/22.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

enum LogInType: String {
    case apple
    case email
    case facebook
    case google
    case kakao
    case naver
}

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let loginView = LoginView()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addActionToLoginButton()
        self.addActionToSignInButton()
        self.setTextFieldDelegate()
        self.addActionToSNSLoginButtons()
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.loginView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationController()
        self.addObserverForPresent()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeObserverForPresent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.loginView.endEditing(true)
    }
        
    // MARK: - Heleprs
    
    private func setNavigationController(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // login 성공 시 화면전환을 위한 observer.
    private func addObserverForPresent() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveToMainTabController), name: Notification.Name.userLogin, object: nil)
    }
    private func removeObserverForPresent() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.userLogin, object: nil)
    }
    @objc func moveToMainTabController() {
        self.present(MainTabBarController(), animated: false)
    }

    
    // MARK: - Email Login part (임시)
    
    private func addActionToLoginButton() {
        self.loginView.loginButton.addTarget(self, action: #selector(moveToMainVC), for: .touchUpInside)
    }
    
    @objc private func moveToMainVC() {
        guard self.loginView.emailTextField.hasText == true && self.loginView.passwordTextField.hasText == true else {
            // 조건에 맞지 않는 텍스트를 입력한 사용자에게 email/password 제대로 입력해달라는 alert.
            return }
        self.loginWithEmail { bool in
            if bool {
                // 로그인 완료되면 메인 화면으로 이동.
                self.present(MainTabBarController(), animated: false)
                UserDefaults.standard.setValue(LogInType.email.rawValue, forKey: UserDefaultsKey.loginCase)
            } else {
                self.showAlert("사용자 정보 없음", "Email을 확인해주세요.", nil)
            }
        }
    }
    
    // email, password 사용해 로그인
    private func loginWithEmail(_ completion: (Bool) -> Void) {
        guard let email = self.loginView.emailTextField.text, let password = self.loginView.passwordTextField.text else { return }
        print("email \(email), password \(password)")
        // 본래 login api를 통해 로그인 시도 결과값 리턴하는 부분
        guard UserDefaults.standard.value(forKey: UserDefaultsKey.userEmail) as? String == self.loginView.emailTextField.text else {
            print("DEBUG: \(UserDefaults.standard.value(forKey: UserDefaultsKey.userEmail))")
            completion(false)
            return
        }
        completion(true)
    }

    
    // MARK: - SNS Login part
    
    private func addActionToSNSLoginButtons() {
        self.loginView.googleSignInButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
        self.loginView.appleSignInButton.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        self.loginView.facebookSignInButton.addTarget(self, action: #selector(signInWithFacebook), for: .touchUpInside)
        self.loginView.naverSignInButton.addTarget(self, action: #selector(logInWithNaver), for: .touchUpInside)
        self.loginView.kakaoSignInButton.addTarget(self, action: #selector(logInWithKakao), for: .touchUpInside)
    }
    
        // MARK: - Google sign in
    
    @objc private func signInWithGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil, let signInResult else { return }
            let user = signInResult.user
            // profile 필수 수신 구현 확인 필요
            guard let email = user.profile?.email, let userName = user.profile?.name else {
                print("DEBUG: no google user profile email/fullname")
                return
            }
            print("DEBUG: google user accessToken \(user.accessToken)")
            print("DEBUG: google user idToken \(user.idToken)")
            print("DEBUG: google user refreshToken \(user.refreshToken)")
            UserDefaults.standard.setValue(LogInType.google.rawValue, forKey: UserDefaultsKey.loginCase)
            NetworkLogInManager.shared.fetchUserSignUp(email: email, userName: userName, logInType: .google)
        }
    }
    
        // MARK: - Apple Sign In
    @objc private func signInWithApple(){
        guard let window = self.view.window else { return }
        AppleSignInManager.shared.signInWithApple(window: window)
        UserDefaults.standard.setValue(LogInType.apple.rawValue, forKey: UserDefaultsKey.loginCase)
        
    }
    
        // MARK: - Facebook Sign In
    @objc private func signInWithFacebook() {
        FacebookLogInManager.shared.logInWithFacebook()
        UserDefaults.standard.setValue(LogInType.facebook.rawValue, forKey: UserDefaultsKey.loginCase)
    }
    
        // MARK: - Naver Log In
    @objc private func logInWithNaver() {
        NaverLogInManager.shared.logIn()
        UserDefaults.standard.setValue(LogInType.naver.rawValue, forKey: UserDefaultsKey.loginCase)
    }
    
        // MARK: - Kakao Log In
    @objc private func logInWithKakao() {
        KakaoLogInManager.shared.logInWithKakao()
    }
    
    // MARK: - Sign In VC로 이동
    
    private func addActionToSignInButton() {
        self.loginView.signInButton.addTarget(self, action: #selector(moveToSignInViewController), for: .touchUpInside)
    }
    
    @objc private func moveToSignInViewController() {
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
    }
}

// MARK: - TextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func setTextFieldDelegate() {
        self.loginView.emailTextField.delegate = self
        self.loginView.passwordTextField.delegate = self
    }
    
    // 후에 textfield값 처리를 위해...
    
}
