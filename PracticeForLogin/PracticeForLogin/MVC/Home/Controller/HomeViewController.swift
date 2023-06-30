//
//  HomeViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/27.
//

import SnapKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let homeView = HomeView()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationController()
        self.setUserNameToLabel()
        self.addActionToSampleButton()
        self.addActionToFoodButton()
        self.addActionToOnlyTableButton()
        self.addActionToSignoutButton()
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.homeView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Helpers

    private func setUserNameToLabel() {
        guard let userName = UserDefaults.standard.value(forKey: UserDefaultsKey.UserName) as? String else {
            print("DEBUG: No userName in UserDefaults")
            return
        }
        self.homeView.userNameLabel.text = "Welcome \(userName)!"
    }
    
    private func setNavigationController() {
        self.navigationItem.title = "Home"
    }
    
    private func addActionToSampleButton() {
        self.homeView.moveToSampleViewButton.addTarget(self, action: #selector(goToSampleViewController), for: .touchUpInside)
    }

    @objc private func goToSampleViewController() {
        self.navigationController?.pushViewController(SampleViewController(), animated: true)
    }
    
    private func addActionToFoodButton() {
        self.homeView.moveToFoodDetailButton.addTarget(self, action: #selector(goToFoodDetailViewController), for: .touchUpInside)
    }

    @objc private func goToFoodDetailViewController() {
        self.navigationController?.pushViewController(FoodViewController(), animated: true)
    }
    
    private func addActionToOnlyTableButton() {
        self.homeView.moveToOnlyTableButton.addTarget(self, action: #selector(goToOnlyTableViewController), for: .touchUpInside)
    }

    @objc private func goToOnlyTableViewController() {
        self.navigationController?.pushViewController(OnlyTableViewController(), animated: true)
    }
    
    private func addActionToSignoutButton() {
        self.homeView.signoutButton.addTarget(self, action: #selector(doSignout), for: .touchUpInside)
    }
    
    @objc private func doSignout() {
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
