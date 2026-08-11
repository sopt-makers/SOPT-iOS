//
//  Demo.swift
//  AuthFeatureDemo
//
//  Created by 김영인 on 2023/04/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit


import BaseFeatureDependency

import AuthFeature
import AuthFeatureInterface

import Domain
import Core


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DIContainer.shared.register(
            interface: SignInRepositoryInterface.self,
            implement: { StubSignInRepository() }
        )
        DIContainer.shared.register(
            interface: CoreOAuthRepositoryInterface.self,
            implement: { StubCoreOAuthRepository() }
        )
        DIContainer.shared.register(
            interface: CoreAuthRepositoryInterface.self,
            implement: { StubCoreAuthRepository() }
        )
        DIContainer.shared.register(
            interface: PhoneVerifyRepositoryInterface.self,
            implement: { StubPhoneVerifyRepository() }
        )
        DIContainer.shared.register(
            interface: AuthTokensRepositoryInterface.self,
            implement: { StubAuthTokensRepository() }
        )


        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application( _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application( _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var rootController: UINavigationController {
        return self.window!.rootViewController as? UINavigationController ?? UINavigationController(rootViewController: UIViewController())
    }
    
    lazy var authCoordinator: AuthCoordinator = AuthCoordinator(navigationController: rootController, factory: AuthBuilder())
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
        
        self.authCoordinator.start(by: .root)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

