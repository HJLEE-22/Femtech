//
//  UIImageView.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/30.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    // MARK: - KingFisher를 이용해 url을 받아 이미지 캐시 처리해 바로 imageView에 적용
    func setImage(with urlString: String, cashSize: CGSize) {
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { [weak self] result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    self?.image = image
                } else {
                    guard let url = URL(string: urlString) else { return }
                    let resource = ImageResource(downloadURL: url, cacheKey: urlString)
                    let processor = DownsamplingImageProcessor(size: cashSize)
                    self?.kf.setImage(with: resource, options: [.processor(processor)] )
                }
            case .failure(let error):
                print("DEBUG: error \(error.localizedDescription)")
            }
        }
    }
}
