//
//  TriviaApiServiceDefault.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 01.08.2025.
//

import Foundation

final class TriviaApiServiceDefault: TriviaApiService {
    
    // MARK: - Private Properties
    
    private let networkService: NetworkService
    
    //MARK: - Init
    
    init(networkService: NetworkService = NetworkServiceDefault(baseURL: ApiConstants.baseURL)) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    
    func fetchQuestions(
        amount: Int = ApiConstants.defaultAmount,
        category: Int? = nil,
        difficulty: QuestionDifficulty? = nil,
        type: QuestionType? = nil
    ) async throws -> [Question] {
        
        var queryItems = [
            URLQueryItem(name: "amount", value: "\(amount)"),
            URLQueryItem(name: "encode", value: ApiConstants.encodeType)
        ]
        
        if let category {
            queryItems.append(URLQueryItem(name: "category", value: "\(category)"))
        }
        
        if let difficulty {
            queryItems.append(URLQueryItem(name: "difficulty", value: difficulty.rawValue))
        }
        
        if let type {
            queryItems.append(URLQueryItem(name: "type", value: type.rawValue))
        }
        
        let response: QuestionsResponse = try await networkService.request(
            endpoint: "api.php",
            queryItems: queryItems
        )
        
        try handleResponseCode(response.responseCode)
        return response.results
    }
    
    // MARK: - Private Methods
    
    private func handleResponseCode(_ code: Int) throws {
        switch code {
        case 0: return
        case 1: throw TriviaAPIError.noResults
        case 2: throw TriviaAPIError.invalidParameter
        case 5: throw TriviaAPIError.rateLimit
        default: throw TriviaAPIError.unknownCode(code)
        }
    }
}

// MARK: - TriviaApiServiceDefault Extension

private extension TriviaApiServiceDefault {
    
    // MARK: - API Constants
    
    enum ApiConstants {
        static let baseURL = "https://opentdb.com"
        static let defaultAmount = 5
        static let encodeType = "url3986"
    }
    
    // MARK: - Response Models
    
    struct QuestionsResponse: Decodable {
        let responseCode: Int
        let results: [Question]
        
        enum CodingKeys: String, CodingKey {
            case responseCode = "response_code"
            case results
        }
    }
}
