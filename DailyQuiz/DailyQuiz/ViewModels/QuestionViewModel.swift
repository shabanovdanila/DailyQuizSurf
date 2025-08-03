//
//  QuestionViewModel.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import Foundation
struct DisplayQuestion {
    let id = UUID()
    let type: QuestionType
    let difficulty: QuestionDifficulty
    let category: String
    let question: String
    let correctAnswer: String
    let answers: [String]
    var userSelectedAnswer: String? = nil
    
    init(from question: Question) {
        self.type = question.type
        self.difficulty = question.difficulty
        self.category = question.category
        self.question = question.question
        self.correctAnswer = question.correctAnswer
        self.answers = (question.incorrectAnswers + [question.correctAnswer]).shuffled()
        self.userSelectedAnswer = nil
    }
}

final class QuestionViewModel: ObservableObject {
    private let apiService: TriviaApiService
    
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswer: String?
    @Published var showAnswerFeedback: Bool = false
    @Published var isCorrectAnswer: Bool = false
    @Published var completeQuiz: Bool = false
    @Published var shouldCancelTransitions = false
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var score: Int = 0
    @Published var showError: Bool = false
    
    @Published private(set) var displayQuestions: [DisplayQuestion] = []
    
    private let questionsAmount: Int = 5
    private var type: QuestionType = .multiple
    private(set) var currentCategory: String?
    private(set) var currentDifficulty: String?
    var isFirstQuestion: Bool {
        return currentQuestionIndex == 0
    }
    
    init(apiService: TriviaApiService) {
        self.apiService = apiService
    }
    
    var currentQuestion: DisplayQuestion? {
        return displayQuestions[safe: currentQuestionIndex]
    }
    
    @MainActor
    func loadQuestions(category: Int? = nil, difficulty: QuestionDifficulty? = nil) async {
        if let category {
            self.currentCategory = TriviaCategory.category(id: category)?.name
        }
        self.currentDifficulty = difficulty?.rawValue.capitalized
        
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        showError = false
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
            showError = true
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
        guard !shouldCancelTransitions else { return }
        
        showAnswerFeedback = false
        selectedAnswer = nil
        
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            completeQuiz = true
        }
    }
    
    @MainActor
    func cancelAllTransitions() {
        shouldCancelTransitions = true
        showAnswerFeedback = false
        selectedAnswer = nil
    }
    
    @MainActor
    func resetQuiz() {
        questions = []
        displayQuestions = []
        currentQuestionIndex = 0
        selectedAnswer = nil
        showAnswerFeedback = false
        isCorrectAnswer = false
        completeQuiz = false
        score = 0
        error = nil
        shouldCancelTransitions = false
        isLoading = false
        showError = false
    }
    
    func prepareQuizData() -> QuizData {
        let questions = displayQuestions.map { question in
            QuestionData(
                text: question.question,
                userAnswer: question.userSelectedAnswer ?? getRandomIncorrectAnswer(for: question),
                allAnswers: question.answers,
                correctAnswer: question.correctAnswer,
                isCorrect: question.userSelectedAnswer == question.correctAnswer
            )
        }
        return QuizData(
            name: nil,
            date: Date(),
            category: currentCategory ?? "Unknown",
            difficulty: currentDifficulty ?? "Unknown",
            score: score,
            questions: questions
        )
    }
    func updateSelectedAnswer(for questionId: UUID, answer: String) {
        if let index = displayQuestions.firstIndex(where: { $0.id == questionId }) {
            var updatedQuestions = displayQuestions
            updatedQuestions[index].userSelectedAnswer = answer
            displayQuestions = updatedQuestions
        }
    }
}
extension QuestionViewModel {
    private func getRandomIncorrectAnswer(for question: DisplayQuestion) -> String {
        let incorrectAnswers = question.answers.filter { $0 != question.correctAnswer }
        return incorrectAnswers.randomElement() ?? "No answer selected"
    }
}
