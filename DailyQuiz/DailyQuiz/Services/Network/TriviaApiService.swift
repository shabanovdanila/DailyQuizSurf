//
//  TriviaApiService.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 01.08.2025.
//

import Foundation

//MARK: - TriviaApiService Protocol

protocol TriviaApiService {
    func fetchQuestions(
        amount: Int,
        category: Int?,
        difficulty: QuestionDifficulty?,
        type: QuestionType?
    ) async throws -> [Question]
}

// MARK: - TriviaAPI Errors Enum

enum TriviaAPIError: Error, LocalizedError {
    case noResults
    case invalidParameter
    case rateLimit
    case unknownCode(Int)
    
    var localizedDescription: String? {
        switch self {
        case .noResults: return "No results"
        case .invalidParameter: return "Invalid params"
        case .rateLimit: return "Rate limit"
        case .unknownCode(let code): return "Unknown response code: \(code)"
        }
    }
}
