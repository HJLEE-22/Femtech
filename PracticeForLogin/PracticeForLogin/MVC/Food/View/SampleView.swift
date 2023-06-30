//
//  SampleView.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/27.
//

import SnapKit

final class SampleView: UIView {
    
    // MARK: - Properties

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    let contentView = UIView()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.sampleView1, self.sampleView2, self.sampleView3, self.sampleView4])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    private let sampleView1: UIView = {
        let view = UIView()
        view.backgroundColor = .mainMintColor
        return view
    }()
    
    private let sampleView2: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    private let sampleView3: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        return view
    }()
    
    private let sampleView4: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
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
    
    // MARK: - Helpers

    private func setValue() {
        self.backgroundColor = UIColor.viewBackgroundColor
    }

    private func setSubviews() {
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.stackView)
    }
    
    private func setLayout() {
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.right.left.bottom.equalToSuperview()
        }
        self.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self.scrollView)
            make.height.equalTo(self.stackView)
        }
        self.stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.sampleView1.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        self.sampleView2.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.sampleView1.snp.bottom).offset(20)
            make.height.equalTo(300)
        }
        self.sampleView3.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.sampleView2.snp.bottom).offset(20)
            make.height.equalTo(300)
        }
        self.sampleView4.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.sampleView3.snp.bottom).offset(20)
            make.height.equalTo(300)
        }
    }
}
