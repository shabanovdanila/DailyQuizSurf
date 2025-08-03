//
//  TriviaCategory.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import Foundation

struct TriviaCategory: Decodable, Identifiable {
    
    // MARK: - Properties
    
    let id: Int
    let name: String
    
    // MARK: - All Available Categories
    
    static let allCategories: [TriviaCategory] = [
        TriviaCategory(id: 9, name: "General Knowledge"),
        TriviaCategory(id: 10, name: "Entertainment: Books"),
        TriviaCategory(id: 11, name: "Entertainment: Film"),
        TriviaCategory(id: 12, name: "Entertainment: Music"),
        TriviaCategory(id: 13, name: "Entertainment: Musicals & Theatres"),
        TriviaCategory(id: 14, name: "Entertainment: Television"),
        TriviaCategory(id: 15, name: "Entertainment: Video Games"),
        TriviaCategory(id: 16, name: "Entertainment: Board Games"),
        TriviaCategory(id: 17, name: "Science & Nature"),
        TriviaCategory(id: 18, name: "Science: Computers"),
        TriviaCategory(id: 19, name: "Science: Mathematics"),
        TriviaCategory(id: 20, name: "Mythology"),
        TriviaCategory(id: 21, name: "Sports"),
        TriviaCategory(id: 22, name: "Geography"),
        TriviaCategory(id: 23, name: "History"),
        TriviaCategory(id: 24, name: "Politics"),
        TriviaCategory(id: 25, name: "Art"),
        TriviaCategory(id: 26, name: "Celebrities"),
        TriviaCategory(id: 27, name: "Animals"),
        TriviaCategory(id: 28, name: "Vehicles"),
        TriviaCategory(id: 29, name: "Entertainment: Comics"),
        TriviaCategory(id: 30, name: "Science: Gadgets"),
        TriviaCategory(id: 31, name: "Entertainment: Japanese Anime & Manga"),
        TriviaCategory(id: 32, name: "Entertainment: Cartoon & Animations")
    ]
    
    // MARK: - Static Methods
    
    static var categoryNames: [String] {
        allCategories.map { $0.name }
    }
    
    static func category(id: Int) -> TriviaCategory? {
        allCategories.first { $0.id == id }
    }
    
    static func category(byName name: String) -> TriviaCategory? {
        allCategories.first { $0.name == name }
    }
}
