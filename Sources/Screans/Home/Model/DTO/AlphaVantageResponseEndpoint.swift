//
//  AlphaVantageResponseEndpoint.swift
//  MyCoolApp
//
//  Created by Zaitsev Vladislav on 16.08.2025.
//

import Foundation

struct AlphaVantageResponseEndpoint: Endpoint {
    var baseURL = APIRoutes().baseURL

    var path = APIRoutes().stockRoute

    var method = HTTPMethod.get

    var headers: [String: String]?
    
    var queryParameters: [String: String]?
    
    init (symbol: String, interval: String) {
        queryParameters = ["function": "TIME_SERIES_INTRADAY", "symbol": symbol, "interval": interval, "apikey": "34KB0WSBRACY1L9J"]
    }

}
