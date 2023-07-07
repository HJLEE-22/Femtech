//
//  SceneDelegate.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/22.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import FBSDKCoreKit
import NaverThirdPartyLogin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        // 첫 시작은 런치스크린으로. 이후 런치스크린에서 로그인 확인 후 내비게이션 분기처리.
        window.rootViewController = LaunchScreenViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        
        // google sign in 로그인상태 복원
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
          if error != nil || user == nil {
            // Show the app's signed-out state.
              UserDefaults.standard.setValue(false, forKey: UserDefaultsKey.UserExists)
          } else {
            // Show the app's signed-in state.
              UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.UserExists)
          }
        }
        
        // apple sign in 로그인상태 복원
        // 우선 apple login 할 때 주어지는 user info(id)를 userDefaults에 넣어두고, 값이 있을 때만 하단 분기처리 진행.
        if let user = UserDefaults.standard.string(forKey: UserDefaultsKey.AppleUserIdentifier) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: user) { (credentialState, error) in
              switch credentialState {
              case .authorized:
                  UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.UserExists)
              case .revoked, .notFound:
                // Not Authorization Logic
                  UserDefaults.standard.setValue(false, forKey: UserDefaultsKey.UserExists)
              default:
                break
              }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        // 구글 로그인 외부페이지로 연결
        let _ = GIDSignIn.sharedInstance.handle(url)
        // 페이스북 로그인 외부페이지로 연결
        FBSDKCoreKit.ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
        // 네이버 로그인 외부페이지로 연결
        NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(URLContexts.first?.url)
        
    }
}

