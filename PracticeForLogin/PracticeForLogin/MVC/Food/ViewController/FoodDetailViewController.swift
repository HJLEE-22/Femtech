//
//  FoodDetailViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/29.
//

import SnapKit
import WebKit

final class FoodDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let webView = WKWebView()
    var detailPageUrl: String?
    
    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValue()
        self.setSubview()
        self.setLayout()
        self.goFoodDetailWeb()
    }
    

    // MARK: - Helpers

    private func setValue(){
    }
    private func setSubview(){
        self.view.addSubview(self.webView)
    }
    private func setLayout(){
        self.webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func goFoodDetailWeb(){
        guard let urlString = self.detailPageUrl, let url = URL(string: urlString) else {
            print("DEBUG: \(self.detailPageUrl) dosen't work")
            self.dismiss(animated: true)
            return
        }
        self.webView.load(URLRequest(url: url))
    }
}

