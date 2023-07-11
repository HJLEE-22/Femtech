//
//  HomeViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/27.
//

import SnapKit
import GoogleSignIn
import FBSDKLoginKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let homeView = HomeView()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationController()
        self.setUserNameToLabel()
        self.addActionToButtons()
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.homeView
    }
    

    // MARK: - Helpers

    private func setUserNameToLabel() {
        guard let userName = UserDefaults.standard.value(forKey: UserDefaultsKey.userName) as? String,
              let userEmail = UserDefaults.standard.value(forKey: UserDefaultsKey.userEmail) else {
            print("DEBUG: No exact user Info in UserDefaults")
            return
        }
        self.homeView.userNameLabel.text = "Welcome \(userName)!"
        self.homeView.userEmailLabel.text = "\(userEmail)"
    }
    
    private func setNavigationController() {
        self.navigationItem.title = "Home"
    }
    
    private func addActionToButtons() {
        self.homeView.moveToSampleViewButton.addTarget(self, action: #selector(goToSampleViewController), for: .touchUpInside)
        self.homeView.moveToFoodDetailButton.addTarget(self, action: #selector(goToFoodDetailViewController), for: .touchUpInside)
        self.homeView.moveToOnlyTableButton.addTarget(self, action: #selector(goToOnlyTableViewController), for: .touchUpInside)
        self.homeView.signoutButton.addTarget(self, action: #selector(doSignOut), for: .touchUpInside)
    }

    @objc private func goToSampleViewController() {
        self.navigationController?.pushViewController(SampleViewController(), animated: true)
    }

    @objc private func goToFoodDetailViewController() {
        self.navigationController?.pushViewController(FoodViewController(), animated: true)
    }

    @objc private func goToOnlyTableViewController() {
        self.navigationController?.pushViewController(OnlyTableViewController(), animated: true)
    }
    
    @objc private func doSignOut() {
        guard let logInCaseRawValue = UserDefaults.standard.string(forKey: UserDefaultsKey.loginCase) else {
            print("DEBUG: 저장된 로그인 방식 없음")
            return
        }
        let savedLogInCase = LogInCase(rawValue: logInCaseRawValue)
        print("DEBUG: savedLogInCase \(savedLogInCase)")
        switch savedLogInCase {
        case .apple:
//            AppleSignInManager.shared.revokeAppleToken(...
            break
        case .email:
            break
        case .facebook:
            LoginManager().logOut()
        case .google:
            if GIDSignIn.sharedInstance.currentUser != nil {
                GIDSignIn.sharedInstance.signOut()
            }
        case .kakao:
            UserApi.shared.logout { error in
                guard error == nil else {
                    print("DEBUG: \(error!)")
                    return
                }
                print("DEBUG: kakao logout successed")
            }
        case .naver:
            NaverLoginManager.shared.logOut()
        default:
            break
        }
        UserDefaults.standard.setValue(false, forKey: UserDefaultsKey.isUserExists)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userName)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userEmail)
        print("DEBUG: sign out button tapped")
        let loginNavigationController = LoginNavigationController(rootViewController: LoginViewController())
        loginNavigationController.navigationBar.tintColor = .black
        loginNavigationController.modalPresentationStyle = .fullScreen
        self.present(loginNavigationController, animated: false)
    }
    
    
}
