//
//  HistoryPageView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

struct HistoryPageView: View {
    let quizHistory: [QuizHistory]
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.dQpurple
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ZStack {
                        HStack() {
                            Button(action: {
                                dismiss()
                            }) {
                                Image("back_icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: Constants.backSize, height: Constants.backSize)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, Constants.backLeadingPadding)
                        
                        title
                    }
                    .padding(.top, Constants.titleTopPadding)
                    if (quizHistory.isEmpty) {
                        EmptyHistoryView(action: { dismiss() })
                            .padding(.top, Constants.emptyTopPadding)
                            .padding(.horizontal, Constants.emptyHorizontalPadding)
                    } else {
                        VStack(spacing: 0) {
                            ListCardsView(quizHistory: quizHistory)
                                .padding(.top, Constants.cardsTopPadding)
                                .padding(.horizontal, Constants.cardsHorizontalPadding)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
    
    private struct EmptyHistoryView: View {
        let action: () -> Void
        var body: some View {
            VStack(spacing: 0) {
                Text("Вы еще не проходили ни одной викторины")
                    .multilineTextAlignment(.center)
                    .font(AppFontInter.regular.size(20))
                    .foregroundStyle(.black)
                    .padding(.top, Constants.buttonTextTopPadding)
                    .padding(.horizontal, Constants.buttonTextHorizontalPadding)
                Button(action: action) {
                    Text("НАЧАТЬ ВИКТОРИНУ")
                        .font(AppFontInter.black.size(16))
                        .foregroundStyle(.dQwhite)
                        .padding(
                            .vertical, Constants.nextButtonTextVerticalPadding
                        )
                        .padding(
                            .horizontal, Constants.nextButtonTextHorizontalPadding
                        )
                        .background(Color.dQpurple)
                        .clipShape(RoundedRectangle(
                            cornerRadius: Constants.nextButtonCornerRadius
                        ))
                }
                .padding(.top, Constants.nextButtonTopPadding)
                .padding(.bottom, Constants.nextButtonBottomPadding)
            }
            .frame(maxWidth: .infinity)
            .background(.dQwhite)
            .clipShape(RoundedRectangle(cornerRadius: 46))
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
        static let cardsHorizontalPadding: CGFloat = 26
        static let cardsSpacing: CGFloat = 24
        
        //Back button
        static let backSize: CGFloat = 24
        static let backLeadingPadding: CGFloat = 26
        
        //Start button
        static let nextButtonTextVerticalPadding: CGFloat = 15.5
        static let nextButtonTextHorizontalPadding: CGFloat = 51.5
        static let nextButtonCornerRadius: CGFloat = 16
        static let nextButtonTopPadding: CGFloat = 40
        static let nextButtonBottomPadding: CGFloat = 32
        
        static let buttonTextTopPadding: CGFloat = 32
        static let buttonTextHorizontalPadding: CGFloat = 32
        
        //Empty View
        static let emptyTopPadding: CGFloat = 40
        static let emptyHorizontalPadding: CGFloat = 16
    }
}
