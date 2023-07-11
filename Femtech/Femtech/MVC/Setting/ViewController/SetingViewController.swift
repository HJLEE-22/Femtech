//
//  SettingViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/30.
//

import UIKit

final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let settingView = SettingView()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        super.loadView()
        self.view = settingView
    }
    
    // MARK: - Helpers


    

    
}
