//
//  FoodView.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/28.
//

import SnapKit

final class FoodView: UIView {

    // MARK: - Properties

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    // scrollView에 내용을 담기 위한 별도의 contentView 생성 필요.
    let contentView = UIView()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.layer.borderWidth = 5
        tableView.layer.borderColor = UIColor.systemGray5.cgColor
        return tableView
    }()
    private let foodLabel: UILabel = {
        let label = UILabel()
        label.text = "Food List"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let theEndLabel: UILabel = {
        let label = UILabel()
        label.text = "The End"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.adjustsFontSizeToFitWidth = true
        return label
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
        // 스크롤뷰 안에 콘텐트뷰 넣기
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        [self.foodLabel, self.tableView, self.theEndLabel].forEach { self.contentView.addSubview($0) }
    }
    
    private func setLayout() {
        // 콘텐트뷰 사이즈는 scrollView에 맞추되, 스크롤을 원하는 반대 축의 값도 스크롤뷰와 일치
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.right.left.bottom.equalToSuperview()
        }
        self.contentView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
            make.width.equalTo(self.scrollView)
        }
        self.foodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.height.equalTo(100)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
        }
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.foodLabel.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(500)
        }
        self.theEndLabel.snp.makeConstraints { make in
            make.top.equalTo(self.tableView.snp.bottom).offset(50)
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(100)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
        }
    }
}

