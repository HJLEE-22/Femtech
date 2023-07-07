//
//  LgoinViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/22.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.loginView.endEditing(true)
    }
    
    // MARK: - Heleprs
    
    private func setNavigationController(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Email Login (임시)
    
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
        guard UserDefaults.standard.value(forKey: UserDefaultsKey.UserEmail) as? String == self.loginView.emailTextField.text else {
            print("DEBUG: \(UserDefaults.standard.value(forKey: UserDefaultsKey.UserEmail))")
            completion(false)
            return
        }
        completion(true)
    }

    
    // MARK: - SNS Login part
    
    private func addSnsLoginActionsToButtons() {
        self.loginView.googleSignInButton.addTarget(self, action: #selector(signinWithGoogle), for: .touchUpInside)
        self.loginView.appleSignInButton.addTarget(self, action: #selector(signinWithApple), for: .touchUpInside)
        self.loginView.facebookSignInButton.addTarget(self, action: #selector(signinWithFacebook), for: .touchUpInside)
    }
    
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
    
        // MARK: - Google sign in

//    let signinConfig = GIDConfiguration.init(clientID: "233574830896-1a2au8pu6htonotrojmgq6fu2bmd1ag9.apps.googleusercontent.com")
    
    @objc private func signInWithGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil, let signInResult else { return }
            // If sign in succeeded, display the app's main content View.
            
            let user = signInResult.user
            let email = user.profile?.email
            let fullName = user.profile?.name
            // let profileImage = user.profile?.imageURL(withDimension: 320)
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.UserExists)
            UserDefaults.standard.setValue(fullName, forKey: UserDefaultsKey.UserName)
            UserDefaults.standard.setValue(email, forKey: UserDefaultsKey.UserEmail)
            print("DEBUG: user accessToken \(user.accessToken)")
            print("DEBUG: user idToken \(user.idToken)")
            print("DEBUG: user refreshToken \(user.refreshToken)")
            // 로그인 완료되면 메인 화면으로 이동.
            self.present(MainTabBarController(), animated: false)
        }
    }
    
    @objc private func signOutWithGoogle() {
        GIDSignIn.sharedInstance.signOut()
    }
    
        // MARK: - Apple Sign In
    @objc private func signInWithApple(){
        guard let window = self.view.window else { return }
        AppleSignInManager.shared.signInWithApple(window: window)
        
    }
    
        // MARK: - Facebook Sign In
    @objc private func signInWithFacebook() {
        guard let window = self.view.window else { return }
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

    @objc private func logOutWithFacebook() {
        let fbLoginManager = LoginManager()
        fbLoginManager.logOut()
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

// MARK: - facebook login delegate
extension LoginViewController: LoginButtonDelegate {
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
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        
    }

}
