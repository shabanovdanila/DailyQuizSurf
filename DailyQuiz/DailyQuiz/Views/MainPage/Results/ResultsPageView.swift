//
//  ResultsPageView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

// MARK: - ResultsPageView

struct ResultsPageView: View {
    
    // MARK: - Properties
    
    let resultScore: Int
    let action: () -> Void
    
    // MARK: - body
    
    var body: some View {
        VStack(spacing: 0) {
            ResultsView(resultScore: resultScore)
            
            AgainButton(action: action)
                .padding(.horizontal, Constants.buttonHorizontalPadding)
                .padding(.bottom, Constants.buttonBottomPadding)
                .padding(.top, Constants.buttonTopPadding)
        }
        .background(Color.DQwhite)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cardRadius))
    }
}

// MARK: - ResultsPageView Extension

private extension ResultsPageView {
    enum Constants {
        static let cardRadius: CGFloat = 46
        //Button
        static let buttonTopPadding: CGFloat = 64
        static let buttonHorizontalPadding: CGFloat = 40
        static let buttonBottomPadding: CGFloat = 32
    }
}
