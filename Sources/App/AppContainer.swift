//
//  AppContainer.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 07.08.2025.
//

class AppContainer {
    
    lazy var networkService = NetworkService()
    
    func makeHomeViewController() -> StockChartViewController {
        let viewModel = StockChartViewModel(networkService: networkService)
        return StockChartViewController(viewModel: viewModel)
    }
    
    func makeProfileViewController() -> ProfileViewController {
        let viewModel = ProfileViewModel(networkService: networkService)
        return ProfileViewController(viewModel: viewModel)
    }
}
