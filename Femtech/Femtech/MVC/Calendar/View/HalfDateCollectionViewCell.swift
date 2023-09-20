//
//  HalfDateCollectionViewCell.swift
//  Femtech
//
//  Created by Lee on 2023/07/20.
//

import SnapKit

final class HalfDateCollectionViewCell: UICollectionViewCell {
    static let identifier = "HalfDateCollectionViewCell"
    
    // MARK: - Properties
    let dateLabel: UILabel = {
        var label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
        self.setSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    private func setLayout() {
        self.addSubview(self.dateLabel)
    }
    
    private func setSubviews() {
        self.dateLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(10)
        }
    }
    
    func configureDate(to date: Int) {
        let date = "\(date)"
        self.dateLabel.text = date
    }
    
    func isPreviousMonthDate() {
        self.dateLabel.textColor = .lightGray
    }
    
    func isFollowingMonthDate() {
        self.dateLabel.textColor = .lightGray
    }
    
    func isCurrentMonthDate() {
        self.dateLabel.textColor = .black
    }
    
}

    
    


    
    

