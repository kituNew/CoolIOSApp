//
//  HomeStartView.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 07.08.2025.
//

import UIKit
import SnapKit

final class HomeStartView: UIView {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(label)
        label.text = "Hello!"

        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
