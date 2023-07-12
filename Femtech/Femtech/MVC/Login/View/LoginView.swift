//
//  LoginView.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/26.
//

import SnapKit

final class LoginView: UIView {
  
     // MARK: - Properties

     private lazy var appLogo: UIImageView = {
             let imageView = UIImageView()
             imageView.contentMode = .scaleAspectFit
             imageView.image = UIImage(named: "appLogo")
             imageView.clipsToBounds = true
             return imageView
         }()
     
     private lazy var emailTextFieldView: UIView = {
         let view = UIView()
         view.layer.borderColor = UIColor.black.cgColor
         view.layer.borderWidth = 1
         view.layer.cornerRadius = 20
         view.clipsToBounds = true
         view.addSubview(emailTextField)
         self.emailTextField.snp.makeConstraints { make in
             make.left.right.equalToSuperview().inset(10)
             make.centerY.equalToSuperview()
         }
         return view
     }()
     
     lazy var emailTextField: UITextField = {
         let textField = UITextField()
         textField.placeholder = "email"
         textField.font = UIFont.systemFont(ofSize: 13)
         textField.layer.borderColor = .none
         return textField
     }()
     
     private lazy var passwordTextFieldView: UIView = {
         let view = UIView()
         view.layer.borderColor = UIColor.black.cgColor
         view.layer.borderWidth = 1
         view.layer.cornerRadius = 20
         view.clipsToBounds = true
         view.addSubview(passwordTextField)
         self.passwordTextField.snp.makeConstraints { make in
             make.left.right.equalToSuperview().inset(10)
             make.centerY.equalToSuperview()
         }
         return view
     }()
     
     lazy var passwordTextField: UITextField = {
         let textField = UITextField()
         textField.placeholder = "password"
         textField.font = UIFont.systemFont(ofSize: 13)
         textField.layer.borderColor = .none
         textField.isSecureTextEntry = true
         return textField
     }()
     
     private lazy var emailPasswordStackView: UIStackView = {
         let stackView = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView])
         stackView.axis = .vertical
         stackView.distribution = .fillEqually
         stackView.spacing = 20
         return stackView
     }()
     
     lazy var loginButton: UIButton = {
         let button = UIButton(type: .system)
         button.setTitle("로그인", for: .normal)
         button.setTitleColor(.white, for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
         button.backgroundColor = .darkGray
         button.layer.cornerRadius = 20
         button.clipsToBounds = true
         return button
     }()
     
     lazy var signWithAnonymousButton: UIButton = {
         let button = UIButton(type: .system)
         button.setTitle("가입하지 않고 둘러보기", for: .normal)
         button.setTitleColor(UIColor.black, for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
         button.backgroundColor = .none
         button.layer.borderColor = UIColor.black.cgColor
         button.layer.borderWidth = 1
         button.layer.cornerRadius = 20
         button.clipsToBounds = true
         return button
     }()
     
     private lazy var loginButtonStackView: UIStackView = {
         let stackView = UIStackView(arrangedSubviews: [loginButton, signWithAnonymousButton])
         stackView.axis = .vertical
         stackView.distribution = .fillEqually
         stackView.spacing = 20
         return stackView
     }()
     
     
     lazy var signInButton: UIButton = {
         let button = UIButton(type: .system)
         button.setTitle("회원가입", for: .normal)
         button.setTitleColor(UIColor.black, for: .normal)
         button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
         button.backgroundColor = .none
         button.snp.makeConstraints { make in
             make.width.equalTo(50)
             make.height.equalTo(20)
         }
         return button
     }()
     
     lazy var forgotPasswordButton: UIButton = {
         let button = UIButton(type: .system)
         button.setTitle("비밀번호 재설정", for: .normal)
         button.setTitleColor(UIColor.black, for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
         button.backgroundColor = .none
         button.snp.makeConstraints { make in
             make.width.equalTo(80)
             make.height.equalTo(20)
         }
         return button
     }()
     
     private lazy var signInStackView: UIStackView = {
         let stackView = UIStackView(arrangedSubviews: [signInButton, forgotPasswordButton])
         stackView.axis = .horizontal
         stackView.distribution = .fillEqually
         stackView.spacing = 50
         return stackView
     }()
    
    lazy var appleSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "appleIcon"), for: .normal)
//        button.layer.cornerRadius = 20
        button.imageView?.layer.cornerRadius = 8
        button.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
        return button
    }()
    
    lazy var googleSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "googleIcon"), for: .normal)
        button.layer.cornerRadius = 20
        button.imageView?.layer.cornerRadius = 8
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowColor = UIColor.systemGray5.cgColor
        button.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
        return button
    }()
    
    lazy var facebookSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "facebookIcon"), for: .normal)
        button.layer.cornerRadius = 20
        button.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
        return button
    }()
    
    lazy var kakaoSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakaotalkIcon"), for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
        return button
    }()
    
    lazy var naverSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "naverIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 20
        button.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
        return button
    }()
    
    private lazy var socialLoginStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.appleSignInButton, self.googleSignInButton, self.facebookSignInButton, self.kakaoSignInButton, self.naverSignInButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
     
     // MARK: - Lifecycles
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         self.setSubviews()
         self.setLayout()
         self.setValue()
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     
     // MARK: - Helpers
 
     
     private func setValue() {
         self.backgroundColor = UIColor.viewBackgroundColor
     }
     
    // forEach 함수를 통해 self.view에 각 UI 요소들 addSubview.
     private func setSubviews() {
         [self.appLogo, self.emailPasswordStackView, self.loginButtonStackView, self.signInStackView, self.socialLoginStackView]
             .forEach { self.addSubview($0) }
     }

     private func setLayout() {
         self.appLogo.snp.makeConstraints { make in
             make.centerX.equalToSuperview()
             make.top.equalToSuperview().inset(120)
         }
         self.emailPasswordStackView.snp.makeConstraints { make in
             make.left.right.equalToSuperview().inset(50)
             make.top.equalTo(self.appLogo.snp.bottom).offset(40)
             make.height.equalTo(100)
         }
         self.loginButtonStackView.snp.makeConstraints { make in
             make.left.right.equalToSuperview().inset(120)
             make.top.equalTo(self.emailPasswordStackView.snp.bottom).offset(60)
             make.height.equalTo(100)
         }
         self.signInStackView.snp.makeConstraints { make in
             make.left.right.equalToSuperview().inset(20)
             make.top.equalTo(self.loginButtonStackView.snp.bottom).offset(30)
         }
         self.socialLoginStackView.snp.makeConstraints { make in
             make.left.right.equalToSuperview().inset(40)
             make.top.equalTo(self.signInStackView.snp.bottom).offset(30)
         }
     }
 }

 

