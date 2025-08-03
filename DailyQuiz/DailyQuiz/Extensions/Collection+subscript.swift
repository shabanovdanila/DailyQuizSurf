//
//  Collection+subscript.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import Foundation

// MARK: - Safety Getting Element
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
