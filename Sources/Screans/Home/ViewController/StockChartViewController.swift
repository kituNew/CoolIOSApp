//
//  HomeViewController.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 07.08.2025.
//

import UIKit
import SnapKit
import DGCharts

class StockChartViewController: UIViewController {
    private let viewModel: StockChartViewModel
    private lazy var chartView = StockChartView()
    private lazy var intervalSwitcherView = IntervalSwitcherView(frame: .zero) { [weak self] interval in
        guard let self = self else { return }
        self.loadStockData(currentInterval: interval)
    }
    
    
    init(viewModel: StockChartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadStockData(currentInterval: "1min")
    }
    
    private func loadStockData(currentInterval: String) {
        Task {
            await viewModel.fetchStocks(symbol: "AAPL", interval: currentInterval) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let stock):
                    guard let stock = stock else {
                        print("nil")
                        return
                    }
                    self.updateChart(with: stock)
                case .failure(let error):
                    print("Ошибка: \(error)")
                }
            }
        }
    }
    
    private func setup() {
        view.addSubview(chartView)
        view.addSubview(intervalSwitcherView)
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().offset(16)
            make.height.equalTo(view).multipliedBy(0.4)
        }
        
        intervalSwitcherView.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func updateChart(with stock: Stock) {
        let candles = stock.timeSeries
        
        // Проверяем, что есть данные
        guard !candles.isEmpty else {
            print("Нет данных для отображения")
            return
        }
        
        // Создаём точки графика: x = индекс, y = цена закрытия
        var entries: [ChartDataEntry] = []
        for (index, candle) in candles.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: candle.close))
        }
        
        // Настраиваем линию графика
        let set = LineChartDataSet(entries: entries, label: "\(stock.metaData.symbol) Цена")
        set.setColor(.systemBlue)
        set.lineWidth = 2.0
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        set.drawValuesEnabled = false
        
        // Применяем данные к графику
        let data = LineChartData(dataSet: set)
        chartView.chartView.data = data
        
        // Подписи по оси X: форматируем время
        let labels = candles.map {
            $0.timestamp.formatted(date: .omitted, time: .shortened)
        }
        chartView.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        chartView.chartView.notifyDataSetChanged()
    }
}
