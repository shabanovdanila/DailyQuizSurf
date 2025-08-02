//
//  CategoryViewModel.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import Foundation

final class CategoryViewModel: ObservableObject {
    private let apiService: TriviaApiService
    
    @Published var categories: [TriviaCategory] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var selectedCategory: TriviaCategory?
    
    init(apiService: TriviaApiService) {
        self.apiService = apiService
    }
    
    @MainActor
    func loadCategories() async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        do {
            categories = try await apiService.fetchCategories()
        } catch {
            self.error = error
            categories = []
        }
        
        isLoading = false
    }
    
    func selectCategory(_ category: TriviaCategory) {
        selectedCategory = category
    }
    
    func resetSelection() {
        selectedCategory = nil
    }
    
    var categoryNames: [String] {
        categories.map { $0.name }
    }
    
    func categoryId(for name: String) -> Int? {
        categories.first { $0.name == name }?.id
    }
}
