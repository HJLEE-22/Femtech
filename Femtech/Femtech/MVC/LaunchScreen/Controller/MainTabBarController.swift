//
//  MainTabBarController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/30.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    let homeNavigationContrller = HomeNavigationController(rootViewController: HomeViewController())
//    let settingNavigationController = SettingNavigationController(rootViewController: SettingViewController())
    let calendarNavigationController = CalendarNavigationController(rootViewController: CustomCalendarViewController())
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setControllersInTabBar()
        self.setTabBarUI()
    }

    
    // MARK: - Helpers

    private func setControllersInTabBar() {
        // 컨트롤러 두개 추가
        self.setViewControllers([homeNavigationContrller, calendarNavigationController], animated: false)
    }
    
    private func setTabBarUI() {
        self.modalPresentationStyle = .fullScreen
        self.tabBar.backgroundColor = .mainMintColor
        self.tabBar.tintColor = .systemGray3
        
        guard let items = self.tabBar.items else {
            return
        }
        items[0].image = UIImage(systemName: IconNames.house)
        items[0].selectedImage = UIImage(systemName: IconNames.houseFill)
        items[1].image = UIImage(systemName: IconNames.calendarCircle)
        items[1].selectedImage = UIImage(systemName: IconNames.calendarCircleFill)

        self.selectedIndex = 0
    }
}
