//
//  FiltersView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

//MARK: - FiltersView

struct FiltersView: View {
    
    //MARK: - Properties
    
    let backAction: () -> Void
    let onStartQuiz: () -> Void
    let difficulties = QuestionDifficulty.allValidCases.map { $0.russianName }
    
    @Binding var selectedCategory: String?
    @Binding var selectedDifficulty: String?
    @State private var showingCategorySheet = false
    @State private var showingDifficultySheet = false
    
    
    //MARK: - body
    
    var body: some View {
        
        VStack(spacing: 0) {
            FiltersCard(
                backAction: backAction,
                categoryAction: { showingCategorySheet = true },
                diffAction: { showingDifficultySheet = true },
                nextButtonAction: onStartQuiz,
                selectedCategory: selectedCategory,
                selectedDifficulty: selectedDifficulty
            )
        }
        .sheet(isPresented: $showingCategorySheet) {
            SelectionSheet(
                title: "Категория",
                items: TriviaCategory.categoryNames,
                selectedItem: $selectedCategory
            )
        }
        .sheet(isPresented: $showingDifficultySheet) {
            SelectionSheet(
                title: "Сложность",
                items: difficulties,
                selectedItem: $selectedDifficulty
            )
        }
    }
}
