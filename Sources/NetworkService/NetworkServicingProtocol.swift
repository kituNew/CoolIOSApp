//
//  NetworkServicingProtocol.swift
//  SiriusYoungCon
//
//  Created by Владимир Мацнев on 31.03.2025.
//

import Foundation
import UIKit

protocol NetworkServicing {
    func request<Request: Encodable, Response: Decodable>(
        endpoint: Endpoint,
        requestDTO: Request
    ) async throws -> Response
    
    func downloadImage(from url: URL) async throws -> UIImage
    
    func saveImageToCache(uiImage: UIImage, url: URL) throws
    
    func fetchImageFromCache(url: URL) throws -> UIImage?
}
