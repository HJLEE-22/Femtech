//
//  HomeView.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/27.
//

import SnapKit

final class HomeView: UIView {
    
    // MARK: - Properties
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.mainMintColor
        label.text = "안녕하세요"
        label.textAlignment = .center
        return label
    }()
    
    lazy var userEmailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.mainMintColor
        label.text = "sample@gmail.com"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var moveToSampleViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to scrollView sample", for: .normal)
        button.setTitleColor(UIColor.mainMintColor, for: .normal)
        button.backgroundColor = .systemGray5
        return button
    }()
    
    lazy var moveToFoodDetailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to food detail", for: .normal)
        button.setTitleColor(UIColor.mainMintColor, for: .normal)
        button.backgroundColor = .systemGray5
        return button
    }()
    
    lazy var moveToOnlyTableButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to only tableView", for: .normal)
        button.setTitleColor(UIColor.mainMintColor, for: .normal)
        button.backgroundColor = .systemGray5
        return button
    }()
    
    lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign out", for: .normal)
        button.setTitleColor(UIColor.mainMintColor, for: .normal)
        button.backgroundColor = .systemGray5
        return button
    }()
    
    lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(UIColor.mainMintColor, for: .normal)
        button.backgroundColor = .systemGray5
        return button
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setValue()
        self.setSubviews()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    private func setValue() {
        self.backgroundColor = UIColor.viewBackgroundColor
    }

    private func setSubviews() {
        [self.userNameLabel,self.userEmailLabel, self.moveToFoodDetailButton, self.moveToSampleViewButton, self.moveToOnlyTableButton, self.signOutButton, self.logOutButton].forEach { self.addSubview($0) }
    }
    
    private func setLayout() {
        self.userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(50)
            make.left.right.equalToSuperview().inset(50)
        }
        self.userEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(self.userNameLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        self.moveToSampleViewButton.snp.makeConstraints { make in
            make.top.equalTo(self.userEmailLabel.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(100)
        }
        self.moveToFoodDetailButton.snp.makeConstraints { make in
            make.top.equalTo(self.moveToSampleViewButton.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(100)
        }
        self.moveToOnlyTableButton.snp.makeConstraints { make in
            make.top.equalTo(self.moveToFoodDetailButton.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(100)
        }
        self.signOutButton.snp.makeConstraints { make in
            make.top.equalTo(self.moveToOnlyTableButton.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(100)
        }
        self.logOutButton.snp.makeConstraints { make in
            make.top.equalTo(self.signOutButton.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(100)
        }
    }
}
