//
//  ViewController.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 04.08.2025.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        view.addSubview(label)
        label.text = "Hello SnapKit!"

        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
