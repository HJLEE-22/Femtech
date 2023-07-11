//
//  SettingView.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/30.
//

import SnapKit

final class SettingView: UIView {
    
    // MARK: - Properties
    
    
    
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setValue()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers

    private func setValue() {
        self.backgroundColor = .systemBlue
    }


    
    
    
    
    
}
