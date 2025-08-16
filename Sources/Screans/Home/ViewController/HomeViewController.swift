//
//  HomeViewController.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 07.08.2025.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view = HomeStartView()
    }
}
