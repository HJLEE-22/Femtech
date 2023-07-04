//
//  LaunchScreenViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/27.
//

import SnapKit
import Lottie

enum NaviType {
    case home
    case login
}

final class LaunchScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var animationView: LottieAnimationView = {
        let lottie = LottieAnimationView(name: AnimationNames.dropPongYellow)
        lottie.backgroundColor = UIColor.mainMintColor
        return lottie
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValue()
        self.setSubviews()
        self.setLayout()
        self.addAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NotificattionNames.userLogin, object: nil)
    }
    
    // MARK: - Helpers

    private func setValue() {
        self.view.backgroundColor = UIColor.mainMintColor
    }

    private func setSubviews() {
        self.view.addSubview(self.animationView)
    }
    
    private func setLayout() {
        self.animationView.frame = self.view.bounds
        self.animationView.center = self.view.center
        self.animationView.alpha = 1
    }
        // MARK: - Lottie Animation 적용

    private func addAnimation() {
        self.animationView.play { _ in
            UIView.animate(withDuration: 0.3, animations: { self.animationView.alpha = 0 }) { _ in
                self.animationView.isHidden = true
                self.animationView.removeFromSuperview()
                self.registerAuthStateDidChangeEvent()
                NotificationCenter.default.post(name: NotificattionNames.userLogin, object: nil)
            }
        }
    }
    
        // MARK: - 계정 로그인 상태 확인 부분

    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkLoginIn),
                                               name: NotificattionNames.userLogin,
                                               object: nil)
    }
    @objc private func checkLoginIn() {
        guard let isUserExist = UserDefaults.standard.value(forKey: UserDefaultsKey.UserExists) as? Bool else {
            self.selectNavigationController(navigationType: .login)
            return
        }
        if isUserExist {
            self.selectNavigationController(navigationType: .home)
        } else {
            self.selectNavigationController(navigationType: .login)
        }
    }
    private func selectNavigationController(navigationType: NaviType) {
        if navigationType == .home {
            let tabBarController = self.setTabBarController()
            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController, animated: false)
        } else if navigationType == .login {
            let navigation = LoginNavigationController(rootViewController: LoginViewController())
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: false)
        }
    }
    
    
    private func setTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let HomeNavigationContrller = HomeNavigationController(rootViewController: HomeViewController())
        let SettingNavigationController = SettingNavigationController(rootViewController: SettingViewController())
        // 컨트롤러 두개 더 추가
        
        tabBarController.setViewControllers([HomeNavigationContrller, SettingNavigationController], animated: false)
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.tabBar.backgroundColor = .mainMintColor
        tabBarController.tabBar.tintColor = .systemGray3
        
        guard let items = tabBarController.tabBar.items else {
            return UITabBarController()
        }
        
        items[0].image = UIImage(systemName: IconNames.house)
        items[0].selectedImage = UIImage(systemName: IconNames.houseFill)
        items[1].image = UIImage(systemName: IconNames.gearshape)
        items[1].selectedImage = UIImage(systemName: IconNames.gearshapeFill)

        tabBarController.selectedIndex = 0
        
        return tabBarController
    }
}