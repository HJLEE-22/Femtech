//
//  LgoinViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/22.
//

import UIKit

final class LoginViewController: UIViewController {

    // MARK: - Properties

    private let loginView = LoginView()
    
    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addActionToLoginButton()
        self.addActionToSigninButton()
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.loginView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationController()
    }

    // MARK: - Heleprs

    private func setNavigationController(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
        // MARK: - Login 부분

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
                let navigation = HomeNavigationController(rootViewController: HomeViewController())
                navigation.modalPresentationStyle = .fullScreen
                self.present(navigation, animated: false)
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
    
        // MARK: - Sign Out 부분

    private func addActionToSigninButton() {
        self.loginView.signInButton.addTarget(self, action: #selector(moveToSigninViewController), for: .touchUpInside)
    }
    
    @objc private func moveToSigninViewController() {
        self.navigationController?.pushViewController(SigninViewController(), animated: true)
    }

}

