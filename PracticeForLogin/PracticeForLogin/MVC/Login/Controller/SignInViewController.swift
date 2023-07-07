//
//  SignInViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/27.
//

import SnapKit

final class SignInViewController: UIViewController {
    
    // MARK: - Properties

    private let signInView = SignInView()
    
    private var originViewFrameY: CGFloat?
    
    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSignInAction()
        self.setNavigationController()
        self.signInView.signInButton.isEnabled = true
    }
    override func loadView() {
        super.loadView()
        self.view = self.signInView
    }
    
        // MARK: - Keyboard와 화면 up/down 실행
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.signInView.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotifications()
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
    
    private func addSignInAction() {
        self.signInView.signInButton.addTarget(self, action: #selector(doSignIn), for: .touchUpInside)
    }

    @objc private func doSignIn() {
        // 회원 가입을 위한 텍스트필드 입력 조건 적용
        guard let email = self.signInView.emailTextField.text,
              let password = self.signInView.passwordTextField.text,
              let name = self.signInView.nameTextField.text else { return }
        guard email != "" && password != "" && name != "" && email.contains("@") else {
            self.showAlert("가입 오류", "제대로 입력되지 않은 값이 있습니다.", nil)
            return
        }
        // 서버와 통신해 유저 정보 입력 부분
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.UserExists)
        UserDefaults.standard.setValue(signInView.nameTextField.text, forKey: UserDefaultsKey.UserName)
        UserDefaults.standard.setValue(signInView.emailTextField.text, forKey: UserDefaultsKey.UserEmail)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Keyboard 조정
    
    func addKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ noti: NSNotification){
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.originViewFrameY = self.view.frame.origin.y
            self.view.frame.origin.y -= (keyboardHeight)
        }
    }

    @objc func keyboardWillHide(_ noti: NSNotification) {
        self.view.frame.origin.y = originViewFrameY!
    }
}
