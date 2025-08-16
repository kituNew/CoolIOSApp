//
//  AlphaVantageResponseDTO.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 16.08.2025.
//


struct AlphaVantageResponseDTO: ResponseDTO {
    let metaData: MetaDataDTO?
    let timeSeries: [String: CandleDTO]?

    private enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Time Series (5min)"
    }
}

struct MetaDataDTO: ResponseDTO {
    let information: String?
    let symbol: String?
    let lastRefreshed: String?
    let interval: String?
    let outputSize: String?
    let timeZone: String?

    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case symbol = "2. Symbol"
        case lastRefreshed = "3. Last Refreshed"
        case interval = "4. Interval"
        case outputSize = "5. Output Size"
        case timeZone = "6. Time Zone"
    }
}

struct CandleDTO: ResponseDTO {
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String

    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}
