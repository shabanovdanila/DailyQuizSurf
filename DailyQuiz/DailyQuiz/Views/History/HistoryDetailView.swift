//
//  HistoryDetailView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 03.08.2025.
//

import SwiftUI
import CoreData

// MARK: - HistoryDetailView

struct HistoryDetailView: View {

    // MARK: - Properties

    @EnvironmentObject private var navigationManager: NavigationManager
    let quiz: QuizHistory
    private var questions: [QuestionResult] {
        if let orderedSet = quiz.questions as? NSOrderedSet {
            return orderedSet.array.compactMap { $0 as? QuestionResult }
        } else if let set = quiz.questions as? NSSet {
            return set.allObjects.compactMap { $0 as? QuestionResult }
        }
        return []
    }
    
    // MARK: - body

    var body: some View {
        ZStack {
            Color.DQpurple
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ZStack {
                        HStack() {
                            backButton
                            Spacer()
                        }
                        .padding(.horizontal, Constants.backLeadingPadding)
                        
                        title
                    }
                    .padding(.top, Constants.titleTopPadding)
                    
                    categoryAndDiff
                        .padding(.top, Constants.categoryTopPadding)
                        .padding(.horizontal, Constants.categoryHorizontalPadding)
                    
                    ResultsView(resultScore: Int(quiz.score))
                        .padding(.bottom, Constants.resultInBottomPadding)
                        .frame(maxWidth: .infinity)
                        .background(Color.DQwhite)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.resultRadius))
                        .padding(.top, Constants.resultTopPadding)
                        .padding(.horizontal, Constants.resultHorizontalPadding)
                    
                    textYourAnswer
                        .padding(.top, Constants.textYATopPadding)
                        .padding(.horizontal, Constants.textYAHorizontalPadding)
                    listOfQuestions
                        .padding(.top, Constants.cardsTopPadding)
                        .padding(.horizontal, Constants.cardsHorizontalPadding)
                    againButton
                        .padding(.top, Constants.againButtonTopPadding)
                        .padding(.bottom, Constants.againButtonBottomPadding)
                        .padding(.horizontal, Constants.againButtonHorizontalPadding)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Private SubViews

    private var title: some View {
        Text("Результаты")
            .font(AppFontInter.black.size(Constants.titleTextSize))
            .foregroundStyle(Color.DQwhite)
    }
    
    private var categoryAndDiff: some View {
        VStack(spacing: Constants.categorySpacing) {
            Text("Категория: \(quiz.category ?? "Неизвестно")")
                .font(AppFontInter.regular.size(Constants.categoryAndDiffTextSize))
                .foregroundStyle(Color.DQwhite)
                .multilineTextAlignment(.center)
            Text("Сложность: \(quiz.difficulty ?? "Неизвестно")")
                .font(AppFontInter.regular.size(Constants.categoryAndDiffTextSize))
                .foregroundStyle(Color.DQwhite)
        }
    }
    
    private var textYourAnswer: some View {
        Text("Твои ответы")
            .font(AppFontInter.black.size(Constants.titleTextSize))
            .foregroundStyle(Color.DQwhite)
    }
    
    private var listOfQuestions: some View {
        VStack(spacing: Constants.cardsSpacing) {
            ForEach(Array(questions.enumerated()), id: \.element.id) { index, question in
                HistoryDetailCardView(
                    question: question,
                    numberOfQuestion: index + 1
                )
                .padding(.horizontal, Constants.cardsInHorizontalPadding)
                .padding(.vertical, Constants.cardsInVerticalPadding)
                .background(Color.DQwhite)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cardsRadius))
            }
        }
    }
    
    private var againButton: some View {
        Button(action: {
            navigationManager.popToRoot()
        }) {
            Text("НАЧАТЬ ЗАНОВО")
                .font(AppFontInter.black.size(Constants.textAgainSize))
                .foregroundStyle(Color.DQdarkPurple)
                .padding(.horizontal, Constants.textAgainButtonHorizontalPadding)
                .padding(.vertical, Constants.textAgainButtonVerticalPadding)
                .background(Color.DQwhite)
                .clipShape(RoundedRectangle(cornerRadius: Constants.againRadius))
        }
    }
    
    private var backButton: some View {
        Button(action: {
            navigationManager.pop()
        }) {
            Image("back_icon")
                .frame(width: Constants.backSize, height: Constants.backSize)
        }
    }
}

// MARK: - HistoryDetailView Extension

private extension HistoryDetailView {
    enum Constants {
        //Title
        static let titleTopPadding: CGFloat = 32
        static let titleHorizontalPadding: CGFloat = 98
        static let titleTextSize: CGFloat = 32
        
        //Category and Diff
        static let categoryTopPadding: CGFloat = 16
        static let categoryHorizontalPadding: CGFloat = 50
        static let categorySpacing: CGFloat = 4
        static let categoryAndDiffTextSize: CGFloat = 16
        
        //Result
        static let resultInBottomPadding: CGFloat = 32
        
        static let resultTopPadding: CGFloat = 24
        static let resultHorizontalPadding: CGFloat = 26
        
        static let resultRadius: CGFloat = 46
        
        //Cards
        static let cardsTopPadding: CGFloat = 24
        static let cardsHorizontalPadding: CGFloat = 26
        static let cardsSpacing: CGFloat = 24
        static let cardsInVerticalPadding: CGFloat = 38
        static let cardsInHorizontalPadding: CGFloat = 30
        static let cardsRadius: CGFloat = 46
        
        //Back button
        static let backSize: CGFloat = 24
        static let backLeadingPadding: CGFloat = 26
        
        //Again button
        static let nextButtonTextVerticalPadding: CGFloat = 15.5
        static let nextButtonTextHorizontalPadding: CGFloat = 67
        static let nextButtonCornerRadius: CGFloat = 16
        static let nextButtonTopPadding: CGFloat = 24
        static let nextButtonBottomPadding: CGFloat = 34
        
        //Text Your Answers
        static let textYATopPadding: CGFloat = 51
        static let textYAHorizontalPadding: CGFloat = 92
        
        //Again button
        static let textAgainButtonVerticalPadding: CGFloat = 15.5
        static let textAgainButtonHorizontalPadding: CGFloat = 67
        static let textAgainSize: CGFloat = 16
        
        static let againButtonHorizontalPadding: CGFloat = 56
        static let againButtonTopPadding: CGFloat = 24
        static let againButtonBottomPadding: CGFloat = 34
        static let againRadius: CGFloat = 16
    }
}
