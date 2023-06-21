//
//  SceneDelegate.swift
//  ProjectDescriptionHelpers
//
//  Created by 양수빈 on 2022/10/01.
//

import UIKit

import Core
import BaseFeatureDependency
import RootFeature

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var rootController: UINavigationController {
        return self.window!.rootViewController as? UINavigationController ?? UINavigationController(rootViewController: UIViewController())
    }
    
    lazy var appCoordinator: ApplicationCoordinator = ApplicationCoordinator(
        router: Router(rootController: rootController)
    )
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
        
        self.appCoordinator.start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        parseContexts(openURLContexts: URLContexts)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
