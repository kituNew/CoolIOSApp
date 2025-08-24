//
//  IntervalSwitcherView.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 22.08.2025.
//

import UIKit
import SnapKit

public final class IntervalSwitcherView: UIView {
    
    public var onSelectionChanged: ((String) -> Void)?
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let indicatorView = UIView()
    
    private var buttons: [UIButton] = []
    private var intervalValues: [String] = []
    private var selectedButton: UIButton?
    
    private var indicatorLeadingConstraint: Constraint?
    private var indicatorWidthConstraint: Constraint?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public convenience init(
        frame: CGRect = .zero,
        intervals: [String] = ["1min", "5min", "15min", "30min", "60min"],
        onSelectionChanged: ((String) -> Void)? = nil
    ) {
        self.init(frame: frame)
        self.onSelectionChanged = onSelectionChanged
        configure(with: intervals)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(stackView)
        addSubview(indicatorView)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
            make.width.lessThanOrEqualToSuperview()
        }
        
        // Indicator
        indicatorView.backgroundColor = .systemBlue
        indicatorView.layer.cornerRadius = 1
        indicatorView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
            make.width.equalTo(0)
            make.leading.equalToSuperview()
        }
    }
    
    public func configure(with intervals: [String], defaultIndex: Int = 0) {
        intervalValues = intervals
        
        // Очистка
        buttons.forEach { $0.removeFromSuperview() }
        buttons = []
        
        for (index, interval) in intervals.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(interval, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.tag = index
            
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
        
        // Устанавливаем начальный выбор
        let safeIndex = min(defaultIndex, buttons.count - 1)
        selectButton(buttons[safeIndex], animate: false)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        let interval = intervalValues[index]
        
        selectButton(sender)
        onSelectionChanged?(interval)
    }
    
    private func selectButton(_ button: UIButton, animate: Bool = true) {
        // Сбрасываем состояние
        buttons.forEach { $0.isSelected = false }
        selectedButton = button
        button.isSelected = true
        
        // Обновляем индикатор
        updateIndicator(for: button, animate: animate)
    }
    
    private func updateIndicator(for button: UIButton, animate: Bool) {
        let targetFrame = button.convert(button.bounds, to: self)
        
        // 🔹 Обновляем сохранённые constraints
        indicatorLeadingConstraint?.update(offset: targetFrame.minX)
        indicatorWidthConstraint?.update(offset: targetFrame.width)
        
        // 🔹 Анимация
        let update = { self.layoutIfNeeded() }
        if animate {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: update)
            }
        } else {
            update()
        }
    }
}
