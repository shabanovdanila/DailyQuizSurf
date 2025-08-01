//
//  TriviaApiService.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 01.08.2025.
//

import Foundation

//MARK: - Trivia Category

struct TriviaCategory: Decodable {
    let id: Int
    let name: String
}

//MARK: - TriviaApiService Protocol

protocol TriviaApiService {
    func fetchQuestions(
        amount: Int,
        category: Int?,
        difficulty: QuestionDifficulty?,
        type: QuestionType?
    ) async throws -> [Question]
    
    func fetchCategories() async throws -> [TriviaCategory]
    
    func getSessionToken() async throws -> String
    
    func resetSessionToken() async throws
}

// MARK: - TriviaAPI Errors Enum

enum TriviaAPIError: Error, LocalizedError {
    case noResults
    case invalidParameter
    case tokenNotFound
    case tokenEmpty
    case tokenResetFailed
    case rateLimit
    case tokenRequestFailed(code: Int)
    case tokenNotProvided
    case noActiveSession
    case unknownCode(Int)
    
    var localizedDescription: String? {
        switch self {
        case .noResults: return "No results"
        case .invalidParameter: return "Invalid params"
        case .tokenNotFound: return "Session Token not found"
        case .tokenEmpty: return "Session Token empty"
        case .tokenResetFailed: return "Session Token reset failed"
        case .rateLimit: return "Rate limit"
        case .unknownCode(let code): return "Unknown response code: \(code)"
        case .tokenRequestFailed(code: let code): return "Token request failed: \(code)"
        case .tokenNotProvided: return "Token not provided"
        case .noActiveSession: return "No active token session"
        }
    }
}
