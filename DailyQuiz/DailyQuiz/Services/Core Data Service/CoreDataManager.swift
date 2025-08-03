//
//  CoreDataManager.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
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
        
        let history = QuizHistory(context: context)
        history.setValue(UUID(), forKey: "id")
        history.date = quizData.date
        history.name = generateNextQuizName()
        history.category = quizData.category
        history.difficulty = quizData.difficulty
        history.score = Int16(quizData.score)
        
        quizData.questions.forEach { question in
            let result = QuestionResult(context: context)
            result.setValue(UUID(), forKey: "id")
            result.questionText = question.text
            result.userAnswer = question.userAnswer
            result.isCorrect = question.isCorrect
            result.quizHistory = history
            
            for (index, answer) in question.allAnswers.enumerated() {
                let answerEntity = AllAnswers(context: context)
                answerEntity.id = UUID()
                answerEntity.answerText = answer
                answerEntity.index = Int16(index)
                answerEntity.question = result
            }
        }
        
        saveContext()
    }
    
    private func generateNextQuizName() -> String {
        let request: NSFetchRequest<QuizHistory> = QuizHistory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let lastQuiz = try context.fetch(request).first
            if let lastName = lastQuiz?.name, let lastNumber = Int(lastName.replacingOccurrences(of: "Quiz ", with: "")) {
                return "Quiz \(lastNumber + 1)"
            }
        } catch {
            print("Error fetching last quiz: \(error)")
        }
        return "Quiz 1"
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
            print("Fetch error: \(error)")
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
            print("Fetch questions error: \(error)")
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
