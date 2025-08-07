//
//  HomeViewController.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 07.08.2025.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .brown
    }
}
