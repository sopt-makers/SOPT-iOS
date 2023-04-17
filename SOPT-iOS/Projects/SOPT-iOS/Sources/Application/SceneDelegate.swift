//
//  SceneDelegate.swift
//  ProjectDescriptionHelpers
//
//  Created by 양수빈 on 2022/10/01.
//

import UIKit

import Core
import MainFeature

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let container = DIContainer()

    func scene(_ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        let rootVC = container.makeShowAttendanceVC().viewController
//        let rootVC = container.makeSplashVC().viewController
        window?.rootViewController = UINavigationController(rootViewController: rootVC)
        window?.makeKeyAndVisible()
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
