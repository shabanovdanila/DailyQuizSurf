//
//  String+decode.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

extension String {
    func decodedURLString() -> String {
        return self.removingPercentEncoding ?? self
    }
}
