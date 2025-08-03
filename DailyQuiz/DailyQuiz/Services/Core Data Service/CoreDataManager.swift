//
//  CoreDataManager.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import Foundation
import CoreData

final class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    private init() {}
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DailyQuiz")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save Context
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Quiz History Operations
    
    func saveQuizResult(quizData: QuizData) {
        let context = persistentContainer.viewContext
        
        let history = QuizHistory(context: context)
        history.id = UUID()
        history.date = quizData.date
        history.name = generateNextQuizName()
        history.category = quizData.category
        history.difficulty = quizData.difficulty
        history.score = Int16(quizData.score)
        
        for questionData in quizData.questions {
            let question = QuestionResult(context: context)
            question.id = UUID()
            question.questionText = questionData.text
            question.userAnswer = questionData.userAnswer
            question.correctAnswer = questionData.correctAnswer
            question.isCorrect = questionData.isCorrect
            
            question.quizHistory = history
            
            for (index, answer) in questionData.allAnswers.enumerated() {
                let answerEntity = AllAnswers(context: context)
                answerEntity.id = UUID()
                answerEntity.answerText = answer
                answerEntity.index = Int16(index)
                answerEntity.question = question
            }
        }
        
        do {
            try context.save()
        } catch {
        }
    }
    
    private func generateNextQuizName() -> String {
        let countRequest: NSFetchRequest<QuizHistory> = QuizHistory.fetchRequest()
        do {
            let count = try context.count(for: countRequest)
            print(count)
            return "Quiz \(count)"
        } catch {
            return "Quiz 1"
        }
    }
    func fetchQuizHistory(limit: Int? = nil) -> [QuizHistory] {
        let request: NSFetchRequest<QuizHistory> = QuizHistory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        if let limit = limit {
            request.fetchLimit = limit
        }
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    func fetchQuestions(for quizId: UUID) -> [QuestionResult] {
        let request: NSFetchRequest<QuestionResult> = QuestionResult.fetchRequest()
        request.predicate = NSPredicate(format: "quizHistory.id == %@", quizId as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "questionText", ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    func deleteQuiz(_ quiz: QuizHistory) {
        context.delete(quiz)
        saveContext()
    }
}

// MARK: - Data Models

struct QuizData {
    let name: String?
    let date: Date
    let category: String
    let difficulty: String
    let score: Int
    let questions: [QuestionData]
}

struct QuestionData {
    let text: String
    let userAnswer: String
    let allAnswers: [String]
    let correctAnswer: String
    let isCorrect: Bool
}
