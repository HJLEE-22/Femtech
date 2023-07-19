//
//  WeekdayCollectionViewCell.swift
//  Femtech
//
//  Created by Lee on 2023/07/18.
//

import SnapKit

final class WeekdayCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeekdayCollectionViewCell"
    
    // MARK: - Properties
    let weekdayLabel: UILabel = {
        var label = UILabel()
        label.text = "일"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
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
        self.addSubview(self.weekdayLabel)
    }
    
    private func setSubviews() {
        self.weekdayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureWeekday(to week: String) {
        weekdayLabel.text = week
    }
    
}
