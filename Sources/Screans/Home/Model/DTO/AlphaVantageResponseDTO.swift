//
//  AlphaVantageResponseDTO.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 16.08.2025.
//

// Определим ключ для userInfo
extension CodingUserInfoKey {
    static let timeSeriesInterval = CodingUserInfoKey(rawValue: "timeSeriesInterval")!
}

struct AlphaVantageResponseDTO: ResponseDTO {
    let metaData: MetaDataDTO?
    let timeSeries: [String: CandleDTO]?

    private enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
    }

    init(from decoder: Decoder) throws {
        // Сначала декодируем metaData как обычно
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.metaData = try container.decodeIfPresent(MetaDataDTO.self, forKey: .metaData)

        // Получаем интервал из userInfo
        guard let interval = decoder.userInfo[.timeSeriesInterval] as? String else {
            let context = DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Missing 'timeSeriesInterval' in decoder.userInfo"
            )
            throw DecodingError.dataCorrupted(context)
        }

        let timeSeriesKey = "Time Series (\(interval))"

        // Работаем с верхним уровнем JSON (все ключи)
        let topContainer = try decoder.container(keyedBy: DynamicKey.self)

        // Проверяем, есть ли такой ключ
        if let key = DynamicKey(stringValue: timeSeriesKey),
           topContainer.allKeys.contains(key) {
            let timeSeriesContainer = try topContainer.nestedContainer(keyedBy: DynamicKey.self, forKey: key)

            var candles: [String: CandleDTO] = [:]
            for timestampKey in timeSeriesContainer.allKeys {
                let candle = try timeSeriesContainer.decode(CandleDTO.self, forKey: timestampKey)
                candles[timestampKey.stringValue] = candle
            }
            self.timeSeries = candles
        } else {
            self.timeSeries = nil
        }
    }
}

private struct DynamicKey: CodingKey, Equatable {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    // MARK: - Equatable
    static func == (lhs: DynamicKey, rhs: DynamicKey) -> Bool {
        if lhs.intValue != nil, rhs.intValue != nil {
            return lhs.intValue == rhs.intValue
        }
        return lhs.stringValue == rhs.stringValue
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
