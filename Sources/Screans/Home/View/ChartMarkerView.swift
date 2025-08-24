//
//  ChartMarkerView.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 17.08.2025.
//

import UIKit
import SnapKit
import DGCharts

class ChartMarkerView: MarkerView {
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.backgroundColor = .black.withAlphaComponent(0.8)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        self.offset = CGPoint(x: -frame.width / 2, y: -frame.height - 8)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        self.offset = CGPoint(x: -frame.width / 2, y: -frame.height - 8)
    }

    private func setup() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        label.text = String(format: "%.2f", entry.y) // Показываем цену
        layoutIfNeeded()
    }
}
