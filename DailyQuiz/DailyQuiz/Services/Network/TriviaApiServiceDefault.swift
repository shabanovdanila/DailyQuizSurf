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
    private var sessionToken: String?
    
    //MARK: - Init
    
    init(networkService: NetworkService = NetworkServiceDefault(baseURL: "https://opentdb.com")) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    
    func fetchQuestions(
        amount: Int = 5,
        category: Int? = nil,
        difficulty: QuestionDifficulty? = nil,
        type: QuestionType? = nil
    ) async throws -> [Question] {
        
        var queryItems = [
            URLQueryItem(name: "amount", value: "\(amount)"),
            URLQueryItem(name: "encode", value: "url3986")
        ]
        
        if let token = sessionToken {
            queryItems.append(URLQueryItem(name: "token", value: token))
        }
        
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
    
    func fetchCategories() async throws -> [TriviaCategory] {
        let response: CategoriesResponse = try await networkService.request(
            endpoint: "api_category.php", queryItems: nil
        )
        return response.triviaCategories
    }
    
    func getSessionToken() async throws -> String {
        let response: TokenResponse = try await networkService.request(
            endpoint: "api_token.php",
            queryItems: [URLQueryItem(name: "command", value: "request")]
        )
        
        guard response.responseCode == 0 else {
            throw TriviaAPIError.tokenRequestFailed(code: response.responseCode)
        }
        
        guard let token = response.token else {
            throw TriviaAPIError.tokenNotProvided
        }
        
        self.sessionToken = token
        return token
    }

    func resetSessionToken() async throws {
        guard let currentToken = sessionToken else {
            throw TriviaAPIError.noActiveSession
        }
        
        let response: ResetTokenResponse = try await networkService.request(
            endpoint: "api_token.php",
            queryItems: [
                URLQueryItem(name: "command", value: "reset"),
                URLQueryItem(name: "token", value: currentToken)
            ]
        )
        
        guard response.responseCode == 0 else {
            throw TriviaAPIError.tokenResetFailed
        }
        
        let newToken = response.token ?? currentToken
        self.sessionToken = newToken
    }
    
    // MARK: - Private Methods
    
    private func handleResponseCode(_ code: Int) throws {
        switch code {
        case 0: return
        case 1: throw TriviaAPIError.noResults
        case 2: throw TriviaAPIError.invalidParameter
        case 3: throw TriviaAPIError.tokenNotFound
        case 4: throw TriviaAPIError.tokenEmpty
        case 5: throw TriviaAPIError.rateLimit
        default: throw TriviaAPIError.unknownCode(code)
        }
    }
}

// MARK: - Response Models
private extension TriviaApiServiceDefault {
    
    struct QuestionsResponse: Decodable {
        let responseCode: Int
        let results: [Question]
        
        enum CodingKeys: String, CodingKey {
            case responseCode = "response_code"
            case results
        }
    }
    
    struct CategoriesResponse: Decodable {
        let triviaCategories: [TriviaCategory]
        
        enum CodingKeys: String, CodingKey {
            case triviaCategories = "trivia_categories"
        }
    }
    
    struct TokenResponse: Decodable {
        let responseCode: Int
        let responseMessage: String
        let token: String?
        
        enum CodingKeys: String, CodingKey {
            case responseCode = "response_code"
            case responseMessage = "response_message"
            case token
        }
    }
    
    struct ResetTokenResponse: Decodable {
        let responseCode: Int
        let token: String?
        
        enum CodingKeys: String, CodingKey {
            case responseCode = "response_code"
            case token
        }
    }
}
