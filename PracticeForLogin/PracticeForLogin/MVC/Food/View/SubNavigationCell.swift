//
//  SubNavigationCell.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/29.
//

import SnapKit

final class SubNavigationCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "subNavigationCell"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "sample"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainMintColor
        view.isHidden = true
        return view
    }()
    
    lazy var unselectBottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.isHidden = true
        return view
    }()
    
    // cell 내부에서 cell의 선택시 변동될 ui값 처리.
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
                self.bottomBar.isHidden = false
                self.unselectBottomBar.isHidden = true
            } else {
                self.titleLabel.font = UIFont.systemFont(ofSize: 14)
                self.bottomBar.isHidden = true
                self.unselectBottomBar.isHidden = false
            }
        }
    }

    
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setValue()
        self.setSubview()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func setValue() {

    }
    
    func setSubview() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.bottomBar)
        self.addSubview(self.unselectBottomBar)
    }
    
    func setLayout() {
        self.titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.bottomBar.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.width.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
        self.unselectBottomBar.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
    }
}
