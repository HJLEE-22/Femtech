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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkLoginIn),
                                               name: Notification.Name.userLogin,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.userLogin, object: nil)
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
                NotificationCenter.default.post(name: Notification.Name.userLogin, object: nil)
            }
        }
    }
    
        // MARK: - 계정 로그인 상태 확인 부분

    @objc private func checkLoginIn() {
        guard let isUserExist = UserDefaults.standard.value(forKey: UserDefaultsKey.isUserExists) as? Bool else {
            self.selectNavigationController(navigationType: .login)
            print("DEBUG: no isUserExist")
            return
        }
        if isUserExist {
            print("DEBUG: isUserExist \(isUserExist)")
            self.selectNavigationController(navigationType: .home)
        } else {
            print("DEBUG: isUserExist \(isUserExist)")
            self.selectNavigationController(navigationType: .login)
        }
    }
    private func selectNavigationController(navigationType: NaviType) {
        if navigationType == .home {
            self.present(MainTabBarController(), animated: false)
        } else if navigationType == .login {
            let navigation = LoginNavigationController(rootViewController: LoginViewController())
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: false)
        }
    }
}
