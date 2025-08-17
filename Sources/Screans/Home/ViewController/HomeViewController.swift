//
//  HomeViewController.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 07.08.2025.
//

import UIKit
import SnapKit
import DGCharts

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    private let chartView = HomeStartView()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = chartView
        loadStockData()
    }
    
    private func loadStockData() {
        Task {
            await viewModel.fetchStocks(symbol: "MSFT", interval: "5min") { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let stock):
                    guard let stock = stock else { return }
                    self.updateChart(with: stock)
                case .failure(let error):
                    print("Ошибка: \(error)")
                }
            }
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
        set.mode = .cubicBezier // плавная кривая
        
        // Применяем данные к графику
        let data = LineChartData(dataSet: set)
        chartView.chartView.data = data
        
        // Подписи по оси X: форматируем время
        let labels = candles.map {
            $0.timestamp.formatted(date: .omitted, time: .shortened)
        }
        
        chartView.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        chartView.chartView.xAxis.granularity = 1
        chartView.chartView.xAxis.labelRotationAngle = -45
        chartView.chartView.xAxis.wordWrapEnabled = true
        chartView.chartView.xAxis.avoidFirstLastClippingEnabled = true
        chartView.chartView.rightAxis.enabled = false
        
//        chartView.chartView.leftAxis.granularity = 0.5 // Минимальный шаг (например, 0.5 рубля/доллара)

        // Автоматически рассчитать шаг, но контролировать количество меток
        chartView.chartView.leftAxis.setLabelCount(6, force: true)
        
        set.drawValuesEnabled = false // 🔥 Главное: не показывать значения по умолчанию
        chartView.chartView.highlightPerTapEnabled = true // Разрешить подсветку при тапе
        chartView.chartView.highlightPerDragEnabled = true
        chartView.chartView.marker = ChartMarkerView(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
    }
}
