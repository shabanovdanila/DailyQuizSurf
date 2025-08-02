//
//  HistoryPageView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

struct HistoryPageView: View {
    let quizHistory: [QuizHistory]
    var body: some View {
        ZStack {
            Color.dQpurple
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    title
                        .padding(.top, Constants.titleTopPadding)
                        .padding(.horizontal, Constants.titleHorizontalPadding)
                    ListCardsView(quizHistory: quizHistory)
                        .padding(.top, Constants.cardsTopPadding)
                        .padding(.horizontal, Constants.cardsHorizontalPadding)
                    
                }
            }
        }
    }
    
    private var title: some View {
        Text("История")
            .font(AppFontInter.black.size(32))
            .foregroundStyle(.dQwhite)
    }
    
    private struct ListCardsView: View {
        let quizHistory: [QuizHistory]
        
        var body: some View {
            VStack(spacing: Constants.cardsSpacing) {
                ForEach(quizHistory, id: \.self) { item in
                    HistoryCardView(historyItem: item)
                }
            }
        }
    }
}
private extension HistoryPageView {
    enum Constants {
        //Title
        static let titleTopPadding: CGFloat = 32
        static let titleHorizontalPadding: CGFloat = 126
        
        //Cards
        static let cardsTopPadding: CGFloat = 40
        static let cardsHorizontalPadding: CGFloat = 27
        static let cardsSpacing: CGFloat = 24
    }
}
