//
//  NetworkError.swift
//  SiriusYoungCon
//
//  Created by Владимир Мацнев on 25.03.2025.
//

import Foundation

enum NetworkError: Error {
    case internalError
    case unknownError
    case emailAlreadyExists
    case weakPassword
    case invalidCredentials
    case unverifiedCredentials
    case invalidServerResponseCode(Int)
    case invalidMultipartResponse
    case parsingMultipartError
}
