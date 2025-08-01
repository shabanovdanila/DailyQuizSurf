//
//  ApiPerformer.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 01.08.2025.
//
import Foundation

// MARK: - NetworkService Protocol

protocol NetworkService {
    func request<T: Decodable>(
        endpoint: String,
        queryItems: [URLQueryItem]?
    ) async throws -> T
}

// MARK: - NetworkError Enum

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(DecodingError)
    case networkError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .httpError(let code):
            return "HTTP error (\(code))"
        case .decodingError(let error):
            return "Decode Error: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network Error: \(error.localizedDescription)"
        }
    }
}
