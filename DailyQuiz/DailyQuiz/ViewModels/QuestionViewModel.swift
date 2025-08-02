//
//  QuestionViewModel.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import Foundation

final class QuestionViewModel: ObservableObject {
    private let apiService: TriviaApiService
    
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswer: String?
    @Published var showAnswerFeedback: Bool = false
    @Published var isCorrectAnswer: Bool = false
    @Published var completeQuiz: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var score: Int = 0
    
    @Published private(set) var displayQuestions: [DisplayQuestion] = []
    
    private let questionsAmount: Int = 5
    private var type: QuestionType = .multiple
    
    init(apiService: TriviaApiService) {
        self.apiService = apiService
    }
    
    var currentQuestion: DisplayQuestion? {
        return displayQuestions[safe: currentQuestionIndex]
    }
    
    @MainActor
    func loadQuestions(category: Int? = nil, difficulty: QuestionDifficulty? = nil) async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        do {
            questions = try await apiService.fetchQuestions(
                amount: questionsAmount,
                category: category,
                difficulty: difficulty,
                type: type
            )
            currentQuestionIndex = 0
            displayQuestions = questions.map { DisplayQuestion(from: $0) }
        } catch {
            self.error = error
            questions = []
            displayQuestions = []
        }
        
        isLoading = false
    }
    
    @MainActor
    func selectAnswer(_ answer: String) {
        guard !showAnswerFeedback else { return }
        selectedAnswer = answer
    }
    
    @MainActor
    func submitAnswer() {
        guard let selectedAnswer, let currentQuestion else { return }
        
        isCorrectAnswer = selectedAnswer == currentQuestion.correctAnswer
        showAnswerFeedback = true
        
        if isCorrectAnswer {
            score += 1
        }
    }
    
    @MainActor
    func moveToNextQuestion() {
        showAnswerFeedback = false
        selectedAnswer = nil
        
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            completeQuiz = true
        }
    }
    
    @MainActor
    func resetQuiz() {
        questions = []
        currentQuestionIndex = 0
        selectedAnswer = nil
        showAnswerFeedback = false
        isCorrectAnswer = false
        score = 0
        error = nil
    }
}
