//
//  HistoryPageView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

// MARK: - HistoryPageView

struct HistoryPageView: View {
    
    // MARK: - Properties

    @EnvironmentObject private var navigationManager: NavigationManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \QuizHistory.date, ascending: false)],
        animation: .default
    ) private var quizHistory: FetchedResults<QuizHistory>
    @State private var showDeleteToast = false
    
    // MARK: - body

    var body: some View {
        ZStack {
            Color.DQpurple
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ZStack {
                        HStack() {
                            Button(action: {
                                navigationManager.pop()
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
                        EmptyHistoryView(action: { navigationManager.pop() })
                            .padding(.top, Constants.emptyTopPadding)
                            .padding(.horizontal, Constants.emptyHorizontalPadding)
                    } else {
                        VStack(spacing: 0) {
                            ListCardsView(quizHistory: quizHistory,
                                          showDeleteToast: $showDeleteToast)
                            .padding(.top, Constants.cardsTopPadding)
                            .padding(.horizontal, Constants.cardsHorizontalPadding)
                        }
                    }
                }
            }
            if showDeleteToast {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {}
                
                ToastDeletedView(action: {
                    withAnimation {
                        showDeleteToast = false
                    }
                })
                .padding(.horizontal, Constants.toastHorizontalPadding)
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showDeleteToast)
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Private SubViews

    private var title: some View {
        Text("История")
            .font(AppFontInter.black.size(Constants.titleTextSize))
            .foregroundStyle(Color.DQwhite)
    }
    
    private struct ListCardsView: View {
        @EnvironmentObject private var navigationManager: NavigationManager
        @Environment(\.managedObjectContext) private var viewContext
        var quizHistory: FetchedResults<QuizHistory>
        @Binding var showDeleteToast: Bool
        
        
        var body: some View {
            VStack(spacing: Constants.cardsSpacing) {
                ForEach(quizHistory, id: \.self) { item in
                    HistoryCardView(historyItem: item)
                        .onTapGesture {
                            navigationManager.push(route: .historyDetail(item))
                        }
                        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: Constants.historyCardRadius))
                        .contextMenu {
                            Button(role: .destructive) {
                                deleteQuiz(item)
                                showDeleteToast = true
                            } label: {
                                Label("Удалить", systemImage: "trash")
                            }
                        }
                }
            }
        }
        private func deleteQuiz(_ quiz: QuizHistory) {
            viewContext.delete(quiz)
            do {
                try viewContext.save()
                showDeleteToast = true
            } catch {
            }
        }
    }
    
    // MARK: - EmptyHistoryView

    private struct EmptyHistoryView: View {
        let action: () -> Void
        var body: some View {
            VStack(spacing: 0) {
                Text("Вы еще не проходили ни одной викторины")
                    .multilineTextAlignment(.center)
                    .font(AppFontInter.regular.size(Constants.emptyTitleTextSize))
                    .foregroundStyle(.black)
                    .padding(.top, Constants.buttonTextTopPadding)
                    .padding(.horizontal, Constants.buttonTextHorizontalPadding)
                Button(action: action) {
                    Text("НАЧАТЬ ВИКТОРИНУ")
                        .font(AppFontInter.black.size(Constants.emptyButtonTextSize))
                        .foregroundStyle(Color.DQwhite)
                        .padding(
                            .vertical, Constants.nextButtonTextVerticalPadding
                        )
                        .padding(
                            .horizontal, Constants.nextButtonTextHorizontalPadding
                        )
                        .background(Color.DQpurple)
                        .clipShape(RoundedRectangle(
                            cornerRadius: Constants.nextButtonCornerRadius
                        ))
                }
                .padding(.top, Constants.nextButtonTopPadding)
                .padding(.bottom, Constants.nextButtonBottomPadding)
            }
            .frame(maxWidth: .infinity)
            .background(Color.DQwhite)
            .clipShape(RoundedRectangle(cornerRadius: Constants.emptyRadius))
        }
    }
}

// MARK: - HistoryPageView Extension

private extension HistoryPageView {
    enum Constants {
        //Title
        static let titleTopPadding: CGFloat = 32
        static let titleHorizontalPadding: CGFloat = 126
        static let titleTextSize: CGFloat = 32
        
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
        static let emptyTitleTextSize: CGFloat = 20
        static let emptyButtonTextSize: CGFloat = 16
        static let emptyRadius: CGFloat = 46
        
        //Toast
        static let toastTopPadding: CGFloat = 305
        static let toastHorizontalPadding: CGFloat = 16
        
        //HistoryCard
        static let historyCardRadius: CGFloat = 40
    }
}
