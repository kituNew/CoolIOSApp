//
//  PascalToCamelConverter.swift
//  SiriusYoungCon
//
//  Created by Zaitsev Vladislav on 28.03.2025.
//

import Foundation

extension JSONDecoder.KeyDecodingStrategy {
    static var pascalCaseToCamelCase: JSONDecoder.KeyDecodingStrategy {
        return .custom { codingPath in
            let originalKey = codingPath.last!.stringValue

            // Обработка аббревиатур (если есть)
            if originalKey == originalKey.uppercased() {
                return AnyKey(stringValue: originalKey.lowercased())!
            }

            // Преобразование PascalCase в camelCase
            let firstChar = originalKey.prefix(1).lowercased()
            let camelCaseKey = firstChar + originalKey.dropFirst()

            return AnyKey(stringValue: camelCaseKey)!
        }
    }

    private struct AnyKey: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }

        init?(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }
}
