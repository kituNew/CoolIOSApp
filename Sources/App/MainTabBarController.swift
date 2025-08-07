//
//  MainTabBarController.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 07.08.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
        setupViewControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewControllers() {
        let homeVC = container.makeHomeViewController()
        let profileVC = container.makeProfileViewController()
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: 0
        )
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            tag: 1
        )
        
        // Устанавливаем вкладки
        setViewControllers([homeNav, profileNav], animated: false)
    }
}
