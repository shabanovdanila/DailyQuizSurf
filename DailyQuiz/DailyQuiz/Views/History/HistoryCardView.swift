//
//  HistoryCardView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

struct HistoryCardView: View {
    let historyItem: QuizHistory
    
    var body: some View {
        VStack(spacing: 0) {
            titleStars
                .padding(.top, Constants.titleTopPadding)
                .padding(.horizontal, Constants.titleHorizontalPadding)
            
            dateView
                .padding(.top, Constants.timeTopPadding)
                .padding(.horizontal, Constants.timeHorizontalPadding)
            
            filtersBlockView
                .padding(.top, Constants.filtersTopPadding)
                .padding(.horizontal, Constants.filtersHorizontalPadding)
                .padding(.bottom, Constants.filtersBottomPadding)
        }
        .background(Color.dQwhite)
        .clipShape(RoundedRectangle(cornerRadius: 40))
        
    }
    private func deleteQuizAttempt() {
        CoreDataManager.shared.deleteQuiz(historyItem)
    }
    private var titleStars: some View {
        HStack(spacing: 0) {
            Text(historyItem.name ?? "Quiz")
                .font(AppFontInter.bold.size(24))
                .foregroundStyle(.dQdarkPurple)
            
            Spacer()
            
            StarsView(
                score: Int(historyItem.score),
                starsSpacing: Constants.starsSpacing,
                starSize: Constants.starSize
            )
        }
    }
    
    private var dateView: some View {
        HStack(spacing: 0) {
            Text(historyItem.date?.dayMonthString() ?? "")
                .font(AppFontInter.regular.size(12))
                .foregroundStyle(.black)
            
            Spacer()
            
            Text(historyItem.date?.timeString() ?? "")
                .font(AppFontInter.regular.size(12))
                .foregroundStyle(.black)
        }
    }
    
    private var filtersBlockView: some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Категория: \(historyItem.category ?? "Unknown")")
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Сложность: \(historyItem.difficulty ?? "Unknown")")
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .font(AppFontInter.regular.size(12))
        .foregroundStyle(.black)
    }
}
// MARK: - Constants
private extension HistoryCardView {
    enum Constants {
        // Stars
        static let starsSpacing: CGFloat = 8
        static let starSize: CGFloat = 16
        
        // Title and Stars
        static let titleHorizontalPadding: CGFloat = 24
        static let titleTopPadding: CGFloat = 24
        
        // Time
        static let timeTopPadding: CGFloat = 12
        static let timeHorizontalPadding: CGFloat = 24
        
        // Filters
        static let filtersTopPadding: CGFloat = 12
        static let filtersHorizontalPadding: CGFloat = 24
        static let filtersBottomPadding: CGFloat = 24
    }
}
