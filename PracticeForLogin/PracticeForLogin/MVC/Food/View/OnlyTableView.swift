//
//  OnlyTableView.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/29.
//

import SnapKit

final class OnlyTableView: UIView {

    // MARK: - Properties

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.layer.borderWidth = 5
        tableView.layer.borderColor = UIColor.systemGray5.cgColor
        return tableView
    }()
    // 일단 미사용하는 레이블
    private let foodLabel: UILabel = {
        let label = UILabel()
        label.text = "Food List"
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
        self.addSubview(self.tableView)
    }
    
    private func setLayout() {
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.right.left.bottom.equalToSuperview()
        }
    }
}
