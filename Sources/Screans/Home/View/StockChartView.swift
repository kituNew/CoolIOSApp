//
//  HomeStartView.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 07.08.2025.
//

import UIKit
import SnapKit
import DGCharts

final class StockChartView: UIView {
    public let chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBackground
        chartView.leftAxis.enabled = true
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.legend.enabled = false
        
        chartView.xAxis.granularity = 1
        chartView.xAxis.labelRotationAngle = -45
        chartView.xAxis.wordWrapEnabled = true
        chartView.rightAxis.enabled = false
        chartView.xAxis.setLabelCount(5, force: false)
        chartView.extraBottomOffset = 40
        chartView.xAxis.labelFont = .systemFont(ofSize: 11, weight: .semibold)
        chartView.xAxis.labelTextColor = .darkText
        chartView.leftAxis.setLabelCount(6, force: true)
        chartView.highlightPerTapEnabled = true
        chartView.highlightPerDragEnabled = true
        chartView.marker = ChartMarkerView(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        return chartView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(chartView)
                
        chartView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
