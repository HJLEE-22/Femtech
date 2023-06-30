//
//  SigninViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/27.
//

import SnapKit

final class SigninViewController: UIViewController {
    
    // MARK: - Properties

    private let signinView = SigninView()
    
    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSigninAction()
        self.setNavigationController()
        self.signinView.signInButton.isEnabled = true
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.signinView
    }
    
    // MARK: - Helpers
        // MARK: - 내비게이션 설정

    private func setNavigationController(){
        self.navigationController?.navigationBar.isHidden = false
        // navigation item은 각 VC가 소유한 객체
        self.navigationItem.titleView = self.attributeTitleView()
    }
    
    private func attributeTitleView() -> UIView {
        let label: UILabel = UILabel()
        let titleText: NSMutableAttributedString = NSMutableAttributedString(string: "회원가입", attributes: [
            .foregroundColor: UIColor.mainMintColor,
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ])
        label.attributedText = titleText
        return label
    }
    
        // MARK: - 회원가입 부분
    
    private func addSigninAction() {
        self.signinView.signInButton.addTarget(self, action: #selector(doSignin), for: .touchUpInside)
    }

    @objc private func doSignin() {
        // 회원 가입을 위한 텍스트필드 입력 조건 적용
        guard let email = self.signinView.emailTextField.text,
              let password = self.signinView.passwordTextField.text,
              let name = self.signinView.nameTextField.text else { return }
        guard email != "" && password != "" && name != "" && email.contains("@") else {
            self.showAlert("가입 오류", "제대로 입력되지 않은 값이 있습니다.", nil)
            return
        }
        // 서버와 통신해 유저 정보 입력 부분
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.UserExists)
        UserDefaults.standard.setValue(signinView.nameTextField.text, forKey: UserDefaultsKey.UserName)
        UserDefaults.standard.setValue(signinView.emailTextField.text, forKey: UserDefaultsKey.UserEmail)
        self.navigationController?.popViewController(animated: true)
    }
}
