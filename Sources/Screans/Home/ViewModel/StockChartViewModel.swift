//
//  HomeViewModel.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 07.08.2025.
//

import Foundation

class StockChartViewModel {
    let networkService: NetworkService
        
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchStocks(symbol: String, interval: String, completion: @escaping (Result<Stock?, Error>) -> Void) async {
        var fetchedCandles: AlphaVantageResponseDTO? = nil
        networkService.decoder.userInfo[.timeSeriesInterval] = interval // или "1min", "15min", "30min" и т.д.
        print(interval)
        do {
            let alphaVantageEndpoint = AlphaVantageResponseEndpoint(symbol: symbol, interval: interval)
            let alphaVantageRequest = AlphaVantageResponseRequest()

            fetchedCandles = try await networkService.request(
                endpoint: alphaVantageEndpoint,
                requestDTO: alphaVantageRequest
            )
        } catch {
            await MainActor.run {
                completion(.failure(error))
            }
        }
        
        if fetchedCandles == nil || (fetchedCandles?.metaData == nil && fetchedCandles?.timeSeries == nil) {
            do {
                if let path = Bundle.main.path(forResource: "MSFT5min", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    networkService.decoder.userInfo[.timeSeriesInterval] = "5min"
                    fetchedCandles = try networkService.decoder.decode(AlphaVantageResponseDTO.self, from: data)
                    print("Mock data")
                }
            } catch {
                print(error)
            }
        }
        
        guard let fetchedCandles else {
            completion(.success(nil))
            return
        }
            
        guard let metaData = fetchedCandles.metaData else {
            completion(.success(nil))
            return
        }
        
        guard let metaDatePub = StockMetaData(from: metaData) else {
            completion(.success(nil))
            return
        }
        
        guard let fetchTimeSeries = fetchedCandles.timeSeries else {
            completion(.success(nil))
            return
        }
        
        var timeSeries: [StockCandle?] = fetchTimeSeries.map { timestamp, dto in
            return StockCandle(from: dto, timestamp: timestamp)
        }
        
        timeSeries = timeSeries.filter { $0 != nil }
        var timeSeriesPub: [StockCandle] = timeSeries.compactMap { $0 }

        timeSeriesPub.sort { $0.timestamp < $1.timestamp }
        
        let candle = Stock(metaData: metaDatePub, timeSeries: timeSeriesPub)
                
        await MainActor.run {
            completion(.success(candle))
        }
    }
}
