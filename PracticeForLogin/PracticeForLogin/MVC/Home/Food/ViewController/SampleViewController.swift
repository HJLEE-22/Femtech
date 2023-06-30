//
//  SampleViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/27.
//


import UIKit

final class SampleViewController: UIViewController {
    
    // MARK: - Properties
    
    private let sampleView = SampleView()
    
    private lazy var scrollView = self.sampleView.scrollView
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.sampleView
    }
    
    // MARK: - Helpers

    
}
