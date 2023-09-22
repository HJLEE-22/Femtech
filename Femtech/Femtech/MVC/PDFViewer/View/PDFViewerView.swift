//
//  PDFViewerView.swift
//  Femtech
//
//  Created by Lee on 2023/09/21.
//

import SnapKit
import PDFKit
import UniformTypeIdentifiers

final class PDFViewerView: UIView {
    
    // MARK: - Properties
    
    lazy var browseFileDirectoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Browse Directory", for: .normal)
        button.backgroundColor = .systemGray5
        button.tintColor = .black
        return button
    }()
    
    lazy var browseFileFromURLButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Browse From URL", for: .normal)
        button.backgroundColor = .systemGray5
        button.tintColor = .black
        return button
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setValue()
        self.setSubviews()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Layouts

    private func setValue() {
        self.backgroundColor = .systemBrown
    }
    
    private func setSubviews() {
        [self.browseFileDirectoryButton,
         self.browseFileFromURLButton
        ].forEach { self.addSubview($0) }
        
    }
    
    private func setLayout() {
        self.browseFileDirectoryButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(40)
            make.top.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        self.browseFileFromURLButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(40)
            make.top.equalTo(self.browseFileDirectoryButton.snp.bottom).offset(40)
        }
    }
}
