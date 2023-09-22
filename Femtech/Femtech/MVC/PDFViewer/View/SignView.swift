//
//  SigningView.swift
//  Femtech
//
//  Created by Lee on 2023/09/21.
//

import SnapKit
import TouchDraw


final class SignView: UIView {
    
    // MARK: - Properties
    
    var touchDrawView1: TouchDrawView = {
        let view = TouchDrawView()
        view.backgroundColor = .white
        view.setColor(.black)
        // brush's width
        view.setWidth(3)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    var touchDrawView: TouchDrawView = .init(frame: CGRect(x: 0, y: 0,
                                                            width: 100, height: 100))
    
    private let underbarView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let attachButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.backgroundColor = .systemIndigo
        button.tintColor = .black
        return button
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setValue()
        self.setSubviews()
        self.setLayout()
        self.setTouchDrawView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Layouts

    private func setValue() {
        self.backgroundColor = .systemPurple
    }
    
    private func setSubviews() {
        [self.touchDrawView,
         self.attachButton].forEach { self.addSubview($0) }
        self.touchDrawView.addSubview(self.underbarView)
    }
    
    private func setLayout() {
        self.touchDrawView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(100)
            make.width.height.equalTo(300)
        }
        self.underbarView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(5)
        }
        self.attachButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(40)
            make.top.equalTo(touchDrawView.snp.bottom).offset(50)
        }
    }
    
    private func setTouchDrawView() {
        self.touchDrawView.backgroundColor = .white
        self.touchDrawView.setColor(.black)
        // brush's width
        self.touchDrawView.setWidth(3)
        self.touchDrawView.isUserInteractionEnabled = true
    }
    
}
