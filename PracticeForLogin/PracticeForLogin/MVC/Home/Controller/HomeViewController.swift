//
//  HomeViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/27.
//

import SnapKit
import GoogleSignIn

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
        guard let userName = UserDefaults.standard.value(forKey: UserDefaultsKey.UserName) as? String,
              let userEmail = UserDefaults.standard.value(forKey: UserDefaultsKey.UserEmail) else {
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
        self.homeView.signoutButton.addTarget(self, action: #selector(doSignout), for: .touchUpInside)
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
    
    @objc private func doSignout() {
        if GIDSignIn.sharedInstance.currentUser != nil {
            GIDSignIn.sharedInstance.signOut()
        }
        UserDefaults.standard.setValue(false, forKey: UserDefaultsKey.UserExists)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.UserName)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.UserEmail)
        print("DEBUG: Successfully sign outed")
        let navigation = LoginNavigationController(rootViewController: LoginViewController())
        navigation.navigationBar.tintColor = .black
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation, animated: false)
    }
}
