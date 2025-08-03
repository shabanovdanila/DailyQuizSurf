//
//  Question.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 01.08.2025.
//

import Foundation

// MARK: - Question Type Enum

enum QuestionType: String, Decodable {
    case multiple
    case unknown
    
    init(from decoder: Decoder) throws {
        let сontainer = try decoder.singleValueContainer()
        let typeString = try сontainer.decode(String.self)
        self = QuestionType(rawValue: typeString) ?? .unknown
    }
}

// MARK: - Question Difficulty Enum

enum QuestionDifficulty: String, Decodable, CaseIterable {
    case easy
    case medium
    case hard
    case unknown
    
    var russianName: String {
        switch self {
        case .easy: return "Низкая"
        case .medium: return "Средняя"
        case .hard: return "Сложная"
        case .unknown: return "Неизвестно"
        }
    }
    
    static var allValidCases: [QuestionDifficulty] {
        return [.easy, .medium, .hard]
    }
    
    static func fromRussian(_ name: String) -> QuestionDifficulty? {
        return allCases.first { $0.russianName == name }
    }

    init(from decoder: Decoder) throws {
        let сontainer = try decoder.singleValueContainer()
        let diffString = try сontainer.decode(String.self)
        self = QuestionDifficulty(rawValue: diffString) ?? .unknown
    }
}

// MARK: - Question Model

struct Question: Decodable {
    
    // MARK: - Properties
    
    let type: QuestionType
    let difficulty: QuestionDifficulty
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case type
        case difficulty
        case category
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
    
    // MARK: - Init
    
    init(
        type: QuestionType,
        difficulty: QuestionDifficulty,
        category: String,
        question: String,
        correctAnswer: String,
        incorrectAnswers: [String]
    ) {
        self.type = type
        self.difficulty = difficulty
        self.category = category
        self.question = question.decodedURLString()
        self.correctAnswer = correctAnswer.decodedURLString()
        self.incorrectAnswers = incorrectAnswers.map { $0.decodedURLString() }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(QuestionType.self, forKey: .type)
        self.difficulty = try container.decode(QuestionDifficulty.self, forKey: .difficulty)
        self.category = try container.decode(String.self, forKey: .category).decodedURLString()
        self.question = try container.decode(String.self, forKey: .question).decodedURLString()
        self.correctAnswer = try container.decode(String.self, forKey: .correctAnswer).decodedURLString()
        self.incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers).map { $0.decodedURLString() }
    }
}
