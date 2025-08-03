//
//  HistoryCardView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

// MARK: - HistoryCardView

struct HistoryCardView: View {
    
    // MARK: - Propertiess
    
    let historyItem: QuizHistory
    
    // MARK: - body
    
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
        .background(Color.DQwhite)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cardRadius))
        
    }
    
    // MARK: - Private SubViews
    
    private var titleStars: some View {
        HStack(spacing: 0) {
            Text(historyItem.name ?? "Quiz")
                .font(AppFontInter.bold.size(Constants.historyNameSize))
                .foregroundStyle(Color.DQdarkPurple)
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
            Text(historyItem.date?.dayMonthString() ?? "1 января")
                .font(AppFontInter.regular.size(Constants.dateTextSize))
                .foregroundStyle(.black)
            Spacer()
            Text(historyItem.date?.timeString() ?? "10:00")
                .font(AppFontInter.regular.size(Constants.dateTextSize))
                .foregroundStyle(.black)
        }
    }
    
    private var filtersBlockView: some View {
        VStack(alignment: .center, spacing: Constants.filtersSpacing) {
            Text("Категория: \(historyItem.category ?? "Unknown")")
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Сложность: \(historyItem.difficulty ?? "Unknown")")
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .font(AppFontInter.regular.size(Constants.filtersTextSize))
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
        static let filtersSpacing: CGFloat = 4
        
        // Card
        static let cardRadius: CGFloat = 40
        
        // Text Size
        static let historyNameSize: CGFloat = 24
        static let dateTextSize: CGFloat = 12
        static let filtersTextSize: CGFloat = 12
    }
}
