//
//  OpacityTapGestureRecognizer.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/29.
//

import UIKit

class OpacityTapGestureRecognizer: UITapGestureRecognizer {
    var onTapped: (() -> Void)?
    var opTappedPosition: ((CGPoint) -> Void)?
}

class OpacityLongPressGestureRecognizer: UILongPressGestureRecognizer {
    var onTapped: (() -> Void)?
}



