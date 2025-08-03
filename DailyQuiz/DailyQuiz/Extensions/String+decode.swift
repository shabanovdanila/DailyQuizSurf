//
//  String+decode.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

// MARK: - URL Encoding RFC 3986
extension String {
    func decodedURLString() -> String {
        return self.removingPercentEncoding ?? self
    }
}
