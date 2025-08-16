//
//  Stock.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 16.08.2025.
//

import Foundation

struct Stock {
    let metaData: StockMetaData
    let timeSeries: [StockCandle]
}

struct StockCandle {
    let timestamp: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Int
}

struct StockMetaData {
    let information: String
    let symbol: String
    let lastRefreshed: Date
    let interval: String
    let outputSize: String
    let timeZone: String
}

extension StockCandle {
    init?(from dto: CandleDTO, timestamp: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard
            let date = formatter.date(from: timestamp),
            let open = Double(dto.open),
            let high = Double(dto.high),
            let low = Double(dto.low),
            let close = Double(dto.close),
            let volume = Int(dto.volume)
        else { return nil }
        
        self.timestamp = date
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
    }
}

extension StockMetaData {
    init?(from dto: MetaDataDTO) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let lastRefreshed = dto.lastRefreshed.flatMap { formatter.date(from: $0) }
        
        self.information = dto.information ?? ""
        self.symbol = dto.symbol ?? ""
        self.lastRefreshed = lastRefreshed ?? Date()
        self.interval = dto.interval ?? ""
        self.outputSize = dto.outputSize ?? ""
        self.timeZone = dto.timeZone ?? ""
    }
}
