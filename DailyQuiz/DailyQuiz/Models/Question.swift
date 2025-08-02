//
//  Question.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 01.08.2025.
//

import Foundation

// MARK: - Question Type Enum

enum QuestionType: String, Decodable {
    case multiple = "multiple"
    case unknown
    
    init(from decoder: Decoder) throws {
        let сontainer = try decoder.singleValueContainer()
        let typeString = try сontainer.decode(String.self)
        self = QuestionType(rawValue: typeString) ?? .unknown
    }
}

// MARK: - Question Difficulty Enum

enum QuestionDifficulty: String, Decodable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    case unknown
    
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
    
    let answers: [String]
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case type
        case difficulty
        case category
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
        case answers
    }
    
    // MARK: - Init
    
    init(type: QuestionType, difficulty: QuestionDifficulty, category: String,
         question: String, correctAnswer: String, incorrectAnswers: [String]) {
        self.type = type
        self.difficulty = difficulty
        self.category = category
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
        var allAnswers = incorrectAnswers
        allAnswers.append(correctAnswer)
        self.answers = allAnswers.shuffled()
    }
}
