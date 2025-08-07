//
//  SceneDelegate.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 04.08.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        let container = AppContainer()
        let tabBarController = MainTabBarController(container: container)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

