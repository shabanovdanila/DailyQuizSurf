//
//  FiltersView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

struct FiltersView: View {
    //MARK: - Properties
    let backAction: () -> Void
    let onStartQuiz: () -> Void
    
    @Binding var selectedCategory: String?
    @Binding var selectedDifficulty: String?
    @State private var showingCategorySheet = false
    @State private var showingDifficultySheet = false
    
    let difficulties = ["Низкая", "Средняя", "Высокая"]
    
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
    
    //MARK: - Filters Card
    private struct FiltersCard: View {
        
        let backAction: () -> Void
        let categoryAction: () -> Void
        let diffAction: () -> Void
        let nextButtonAction: () -> Void
        let selectedCategory: String?
        let selectedDifficulty: String?
        
        var body: some View {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("Почти готовы!")
                        .font(AppFontInter.bold.size(24))
                        .foregroundStyle(.black)
                    Text("Осталось выбрать категорию и сложность викторины")
                        .padding(.top, Constants.textTopPadding)
                        .font(AppFontInter.regular.size(16))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, Constants.titleTopPadding)
                
                VStack(spacing: 0) {
                    FilterButton(
                        action: categoryAction,
                        text: "Категория",
                        selectedValue: selectedCategory
                    )
                    FilterButton(
                        action: diffAction,
                        text: "Сложность",
                        selectedValue: selectedDifficulty
                    )
                    .padding(.top, Constants.diffTopPadding)
                }
                .frame(height: 152)
                .padding(.top, Constants.categoryTopPadding)
                .padding(.horizontal, Constants.categoryHorizontalPadding)
                
                Button(action: {
                    if selectedCategory != nil && selectedDifficulty != nil {
                        nextButtonAction()
                    }
                }) {
                    if (selectedCategory != nil && selectedDifficulty != nil) {
                        Text("НАЧАТЬ ВИКТОРИНУ")
                            .font(AppFontInter.black.size(16))
                            .foregroundStyle(.dQwhite)
                            .padding(.horizontal, Constants.nextButtonTextEnabledHorizontalPadding)
                            .padding(.vertical, Constants.nextButtonTextVerticalPadding)
                            .background(Color.dQpurple)
                    } else {
                        Text("ДАЛЕЕ")
                            .font(AppFontInter.black.size(16))
                            .foregroundStyle(.dQwhite)
                            .padding(.horizontal, Constants.nextButtonTextDisabledHorizontalPadding)
                            .padding(.vertical, Constants.nextButtonTextVerticalPadding)
                            .background(Color.dQgray)
                    }
                }
                .disabled(selectedCategory == nil || selectedDifficulty == nil)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.top, Constants.nextButtonTopPadding)
                .padding(.bottom, Constants.nextButtonBottomPadding)
            }
            .background(Color.dQwhite)
            .clipShape(RoundedRectangle(cornerRadius: 46))
        }
    }
    
    private struct FilterButton: View {
        let action: () -> Void
        let text: String
        let selectedValue: String?
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(text)
                            .font(AppFontInter.bold.size(16))
                            .foregroundStyle(.dQdarkPurple)
                        
                        if let selectedValue {
                            Text(selectedValue)
                                .font(AppFontInter.regular.size(14))
                                .foregroundStyle(.black)
                                .padding(.top, 8)
                        }
                    }
                    .padding(.leading, 12)
                    
                    Spacer()
                    
                    Image("right_arrow")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.dQdarkPurple)
                        .frame(width: Constants.rightArrowIconSize,
                               height: Constants.rightArrowIconSize)
                        .padding(.trailing, 12)
                        .padding(.vertical, selectedValue != nil ? 22 : 12)
                }
                .background(Color.dQgrayWhite)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

private extension FiltersView {
    //MARK: - Constants Enum
    enum Constants {
        //FiltersCard
        static let titleTopPadding: CGFloat = 32
        static let titleHorizontalPadding: CGFloat = 24
        
        static let textTopPadding: CGFloat = 12
        static let bottomTextTopPadding: CGFloat = 12
        static let categoryTopPadding: CGFloat = 40
        static let diffTopPadding: CGFloat = 16
        static let categoryHorizontalPadding: CGFloat = 30
        static let nextButtonTopPadding: CGFloat = 39
        static let nextButtonHorizontalPadding: CGFloat = 40
        static let nextButtonBottomPadding: CGFloat = 32
        static let nextButtonTextVerticalPadding: CGFloat = 15.5
        static let nextButtonTextDisabledHorizontalPadding: CGFloat = 111
        static let nextButtonTextEnabledHorizontalPadding: CGFloat = 51.5
        static let rightArrowIconSize: CGFloat = 24
    }
}
//
//#Preview {
//    FiltersView(backAction: {})
//}
