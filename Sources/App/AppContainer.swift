//
//  AppContainer.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 07.08.2025.
//

class AppContainer {
    
    lazy var networkService = NetworkService()
    
    func makeHomeViewController() -> HomeViewController {
        let viewModel = HomeViewModel(networkService: networkService)
        return HomeViewController(viewModel: viewModel)
    }
    
    func makeProfileViewController() -> ProfileViewController {
        let viewModel = ProfileViewModel(networkService: networkService)
        return ProfileViewController(viewModel: viewModel)
    }
}
