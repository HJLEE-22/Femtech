//
//  UIColor.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/27.
//

import UIKit

extension UIColor {
    
    // RGB 값 각각을 나누기 255 할 필요 없음, alpha값 1로 고정
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
            }
    
    // 재사용되는 색상 정리
    static let mainMintColor = UIColor(red: 0, green: 205, blue: 194)
    static let viewBackgroundColor = UIColor.white // 임시
    
    
}
