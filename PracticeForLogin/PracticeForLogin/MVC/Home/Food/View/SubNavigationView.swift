//
//  SubNavigationView.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/29.
//


// 다른 VC에서 재사용을 위해 따로 만든 view.
// 재사용성 보완 필요.
import UIKit

final class SubNavigationView: UIView {
    
    // MARK: - Properties
    
    // 코드로 콜렉션뷰 생성 시 flowLayout과 함께 생성 필요 주의
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: self.frame.width, height: 20), collectionViewLayout: flowLayout)
        collectionView.allowsSelection = true
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    // MARK: - Lifecycles
    
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

    private func setValue() {
        
    }
    private func setSubview() {
        self.addSubview(self.collectionView)
    }
    private func setLayout() {
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
