//
//  FoodCell.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/28.
//

import SnapKit

final class FoodCell: UITableViewCell {
    
    // MARK: - Properties

    static let identifier = "foodCell"

    
    lazy var foodImageView: UIImageView = {
        let image = UIImage(named: "carrot.fill")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.6
        return imageView
    }()
    lazy var foodLabel: UILabel = {
        let label = UILabel()
        label.text = "food sample"
        return label
    }()
    private lazy var cellFrameView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.mainMintColor.cgColor
        view.layer.borderWidth = 3
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    // MARK: - Lifecycles

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setValue()
        self.setSubviews()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Helpers
    
    private func setValue() {
//        self.backgroundColor = .viewBackgroundColor
    }
    
    private func setSubviews() {
        self.addSubview(self.cellFrameView)
        [self.foodImageView, self.foodLabel].forEach{ self.cellFrameView.addSubview($0) }
    }

    private func setLayout() {
        
        self.cellFrameView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        self.foodImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.foodLabel.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview().inset(20)
        }
    }
}
