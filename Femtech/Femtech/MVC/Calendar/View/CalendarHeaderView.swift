//
//  CalendarHeaderView.swift
//  Femtech
//
//  Created by Lee on 2023/07/12.
//

import SnapKit

final class CalendarHeaderView: UIView {
    // MARK: - Properties

    lazy var calendarTitle: UILabel = {
        let label = UILabel()
//        label.text = "2023. 7"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: IconNames.textAlignLeft), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var arrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: IconNames.arrowTriangleDownFill), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: IconNames.magnifyingGlass), for: .normal)
        button.tintColor = .black
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
    
   // forEach 함수를 통해 self.view에 각 UI 요소들 addSubview.
    private func setSubviews() {
        [self.menuButton, self.calendarTitle, self.arrowButton, self.searchButton].forEach { self.addSubview($0) }
    }

    private func setLayout() {
        self.menuButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(25)
        }
        self.calendarTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.menuButton.snp.right).offset(10)
            make.height.equalTo(25)
//            make.width.equalTo(100)
        }
        self.arrowButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.calendarTitle.snp.right).offset(8)
            make.width.height.equalTo(10)
        }
        self.searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
    }
}
