//
//  HomeViewModel.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 07.08.2025.
//

import Foundation

class HomeViewModel {
    let networkService: NetworkService
        
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchStocks(symbol: String, interval: String, completion: @escaping (Result<Stock?, Error>) -> Void) async {
        do {
            let alphaVantageEndpoint = AlphaVantageResponseEndpoint(symbol: symbol, interval: interval)
            let alphaVantageRequest = AlphaVantageResponseRequest()

            let fetchedCandles: AlphaVantageResponseDTO = try await networkService.request(
                endpoint: alphaVantageEndpoint,
                requestDTO: alphaVantageRequest
            )
            
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
        } catch {
            await MainActor.run {
                completion(.failure(error))
            }
        }
    }
}
