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
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.isUserExists)
        UserDefaults.standard.setValue(signInView.nameTextField.text, forKey: UserDefaultsKey.userName)
        UserDefaults.standard.setValue(signInView.emailTextField.text, forKey: UserDefaultsKey.userEmail)
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
    
    @objc func keyboardWillShow(_ notification: NSNotification){
//        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            self.originViewFrameY = self.view.frame.origin.y
//            self.view.frame.origin.y -= (keyboardHeight)
//        }
        
        // n is the notification
//        let d = n.userInfo!
//        var r = d[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//        r = self.slidingView.convert(r, from:nil) // <- this is the key move!
//        let h = self.slidingView.bounds.intersection(r).height
        
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
//        let userInfo1 = notification.userInfo!
//        var keyboardFrame1 = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//        keyboardFrame1 = self.signInView.nameTextField.convert(keyboardFrame1, from: nil)
//        let interSection = self.signInView.nameTextField.bounds.intersection(keyboardFrame1).height
//
//        print("DEBUG:keyboardFrame1 \(keyboardFrame1)")
//        print("DEBUG: interSection\(interSection)")
        
        if self.signInView.nameTextField.isEditing == true {
            self.keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: self.signInView.nameTextField)
        }
        else if self.signInView.emailTextField.isEditing == true {
            self.keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: self.signInView.emailTextField)
        }
        else if self.signInView.passwordTextField.isEditing == true {
            self.keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: self.signInView.passwordTextField)
        }
    }
    
    func keyboardAnimate(keyboardRectangle: CGRect ,textField: UITextField){
//        print("DEBUG:keyboardRectangle \(keyboardRectangle.height)")
//        print("DEBUG:textField maxY \(textField.frame.maxY)")
        if keyboardRectangle.height > (self.view.frame.height - textField.frame.maxY){
            self.view.transform = CGAffineTransform(translationX: 0, y: (self.view.frame.height - keyboardRectangle.height - textField.frame.maxY))
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
//        self.view.frame.origin.y = originViewFrameY!
        self.view.transform = .identity
    }
}
