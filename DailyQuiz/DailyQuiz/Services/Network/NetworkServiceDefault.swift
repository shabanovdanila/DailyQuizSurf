//
//  NetworkServiceDefault.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 01.08.2025.
//

import Foundation

final class NetworkServiceDefault: NetworkService {
    
    // MARK: - Private Properties
    
    private let baseURL: String
    private let urlSession: URLSession
    
    // MARK: - Init
    
    init(baseURL: String, urlSession: URLSession = .shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    // MARK: - Public Methods
    
    func request<T: Decodable>(
        endpoint: String,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {
        guard let url = buildURL(endpoint: endpoint, queryItems: queryItems) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.httpError(statusCode: httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
            
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func buildURL(endpoint: String, queryItems: [URLQueryItem]?) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path = "/\(endpoint)"
        components?.queryItems = queryItems
        return components?.url
    }
}
