//
//  DisplayQuestion.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import Foundation

struct DisplayQuestion {
    let type: QuestionType
    let difficulty: QuestionDifficulty
    let category: String
    let question: String
    let correctAnswer: String
    let answers: [String]
    
    init(from question: Question) {
        self.type = question.type
        self.difficulty = question.difficulty
        self.category = question.category
        self.question = question.question
        self.correctAnswer = question.correctAnswer
        self.answers = (question.incorrectAnswers + [question.correctAnswer]).shuffled()
    }
}
