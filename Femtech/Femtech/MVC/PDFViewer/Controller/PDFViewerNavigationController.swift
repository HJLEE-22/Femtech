//
//  PDFViewerNavigationController.swift
//  Femtech
//
//  Created by Lee on 2023/09/21.
//

import UIKit

final class PDFViewerNavigationController: UINavigationController {
    
    // 커스텀 내용
    // back button icon 변경

    // MARK: - Properties

    private var backButtonImage: UIImage? {
        return UIImage(systemName: IconNames.customBackButton)?.withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -12.0, bottom: -5.0, right: 0.0))
    }
    
    private var touchedBackButtonImage: UIImage? {
        return UIImage(systemName: IconNames.customTouchedBackButton)?.withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -12.0, bottom: -5.0, right: 0.0))
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarAppearance()
    }

    // MARK: - Helpers
    
    func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        
        // 기본 navigation bar 디자인 설정
        appearance.backgroundColor = .viewBackgroundColor
        appearance.shadowImage = colorToImage(.systemGray5)
        
        // back button 설정
        /// transitionMaskImage파라미터: push되거나 pop될때의 backButton 마스크 이미지
        appearance.setBackIndicatorImage(self.backButtonImage, transitionMaskImage: self.touchedBackButtonImage)
        let backButtonAppearance = UIBarButtonItemAppearance()
        
        // backButton하단에 표출되는 text를 안보이게 설정
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear, .font: UIFont.systemFont(ofSize: 0.0)]
        appearance.backButtonAppearance = backButtonAppearance

        // 설정한 디자인을 네비게이션에 적용
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = true
        
        /// navigationItem의 버튼 색상 지정
        navigationBar.tintColor = UIColor.systemGray
    }

    // NavigationBar의 ShadowImage 적용을 위해 UIColor를 UIImage로 변경
    private func colorToImage(_ color: UIColor) -> UIImage {
        let size: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 1)
        let image: UIImage = UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image
    }

}
