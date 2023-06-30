//
//  SigninView.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/27.
//

import SnapKit

final class SigninView: UIView {
    
    // MARK: - Properties

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .mainMintColor
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        return imageView
    }()

    private lazy var plusIconImageView: UIImageView = {
        let image = UIImage(systemName: IconNames.plusCircleFill)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .none
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var imagePickerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .none
        return button
    }()
    
    private lazy var emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var emailTextFieldView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.addSubview(emailTextField)
        return view
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력하세요."
        textField.layer.borderColor = .none
        textField.font = UIFont.systemFont(ofSize: 13)
        return textField
    }()
    
    lazy var emailTextFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.emailTitleLabel ,self.emailTextFieldView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    
    private lazy var passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var passwordTextFieldView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.addSubview(passwordTextField)
        return view
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력하세요."
        textField.layer.borderColor = .none
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var passwordTextFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.passwordTitleLabel ,self.passwordTextFieldView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var nameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var nameTextFieldView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.addSubview(nameTextField)
        return view
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력하세요."
        textField.layer.borderColor = .none
        textField.font = UIFont.systemFont(ofSize: 13)
        return textField
    }()
    
    lazy var nameTextFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.nameTitleLabel ,self.nameTextFieldView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var allTextFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.emailTextFieldStackView ,self.passwordTextFieldStackView, self.nameTextFieldStackView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray3
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        return button
    }()
    
    lazy var openPrivacyPolicyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("개인정보 처리방침", for: .normal)
        button.setTitleColor(UIColor.systemGray3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.backgroundColor = .none
        return button
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setSubViews()
        self.setLayout()
        self.setValue()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers

    
    func setValue() {
        self.backgroundColor = UIColor.viewBackgroundColor
    }
    
    func setSubViews() {
        [self.profileImageView, self.plusIconImageView, self.imagePickerButton, self.allTextFieldStackView, self.signInButton, self.openPrivacyPolicyButton]
            .forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        self.profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(100)
            make.width.height.equalTo(150)
        }
        self.plusIconImageView.snp.makeConstraints { make in
            make.right.equalTo(self.profileImageView.snp.right).inset(7)
            make.bottom.equalTo(self.profileImageView.snp.bottom).inset(7)
            make.top.equalTo(self.profileImageView.snp.top).inset(113)
            make.width.height.equalTo(30)
        }
        self.imagePickerButton.snp.makeConstraints { make in
            make.center.equalTo(self.profileImageView.snp.center)
            make.width.height.equalTo(130)
        }
        [self.emailTextFieldView, self.passwordTextFieldView, self.nameTextFieldView].forEach { $0.snp.makeConstraints
            { make in
                make.width.equalTo(270)
                make.height.equalTo(40)
            }
        }
        [self.emailTextField, self.passwordTextField, self.nameTextField].forEach { $0.snp.makeConstraints
            { make in
                make.height.equalToSuperview()
                make.width.equalToSuperview().inset(10)
                make.centerX.equalToSuperview()
            }
        }
        [self.nameTitleLabel, self.emailTitleLabel, self.passwordTitleLabel].forEach { $0.snp.makeConstraints
            { make in
                make.width.equalTo(60)
                make.height.equalTo(40)
            }
        }
        self.allTextFieldStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.top.equalTo(self.profileImageView.snp.bottom).offset(30)
        }
        self.signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.allTextFieldStackView.snp.bottom).offset(30)
            make.height.equalTo(35)
            make.width.equalTo(100)
        }
        self.openPrivacyPolicyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.signInButton.snp.bottom).offset(8)
            make.width.equalTo(120)
            make.height.equalTo(20)
        }
    }
}
