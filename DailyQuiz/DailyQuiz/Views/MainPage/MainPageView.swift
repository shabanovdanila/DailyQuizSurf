//
//  ContentView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 01.08.2025.
//

import SwiftUI

private enum ContentState: Equatable {
    case welcome
    case filters
    case questions
    case results(score: Int)
}

struct MainPageView: View {
    
    //MARK: - Properties
    @State private var isLoading: Bool = false
    @State private var contentState: ContentState = .welcome
    @State private var isLogoSmall = false
    @State private var selectedCategory: String?
    @State private var selectedDifficulty: String?
    @State private var showTimeoutToast: Bool = false
    @State private var isTransitioning = false
    
    @StateObject private var questionViewModel = QuestionViewModel(apiService: TriviaApiServiceDefault())
    //MARK: - body
    var body: some View {
        ZStack(alignment: .top) {
            Color.dQpurple.ignoresSafeArea()
            VStack(spacing: 0) {
                if contentState == .welcome {
                    HistoryButton()
                        .padding(.top, Constants.topPadding)
                        .transition(.asymmetric(
                            insertion: .move(edge: .top),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                }
                Image("logo_dq")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.dQwhite)
                    .frame(
                        width: isLogoSmall ? Constants.logoSmallSize.width : Constants.logoLargeSize.width,
                        height: isLogoSmall ? Constants.logoSmallSize.height : Constants.logoLargeSize.height
                    )
                    .padding(.top, isLogoSmall ? Constants.logoSmallTopPadding : Constants.logoTopPadding)
                    .animation(.smooth(duration: 0.5), value: isLogoSmall)
                
                if isLoading {
                    Loader()
                        .padding(.top, Constants.loaderTopPadding)
                } else {
                    switch contentState {
                    case .welcome:
                        WelcomeView(startQuiz: startQuiz)
                            .padding(.top, Constants.welcomeViewTopPadding)
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).animation(.easeOut(duration: 0.5)),
                                removal: .move(edge: .bottom).combined(with: .opacity).animation(.easeIn(duration: 0.25))
                            ))
                    case .filters:
                        FiltersView(backAction: backToWelcome, onStartQuiz: {
                            print(12211212)
                            startQuizWithFilters()
                        }, selectedCategory: $selectedCategory, selectedDifficulty: $selectedDifficulty)
                        .padding(.horizontal, Constants.filterHorizontalPadding)
                        .padding(.top, Constants.filterTopPadding)
                        .transition(.move(edge: .trailing))
                    case .questions:
                        if questionViewModel.currentQuestion != nil {
                            QuestionView(
                                question: questionViewModel.currentQuestion!,
                                onQuizComplete: { score in
                                    isTransitioning = true
                                    withAnimation {
                                        contentState = .results(score: score)
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        isTransitioning = false
                                    }
                                }, showTimeoutToast: $showTimeoutToast, viewModel: questionViewModel
                            )
                            .disabled(isTransitioning)
                            .padding(.top, Constants.questionsTopPadding)
                            .padding(.horizontal, Constants.questionsHorizontalPadding)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            ))
                        }
                    case .results(let score):
                        ResultsPageView(
                            resultScore: score,
                            action: {
                                withAnimation {
                                    contentState = .welcome
                                    isLogoSmall = false
                                }
                            }
                        )
                        .padding(.top, Constants.resultsTopPadding)
                        .padding(.horizontal, Constants.resultsHorizontalPadding)
                        .transition(.move(edge: .trailing))
                    }
                }
                if isLoading {
                    tryAgainText()
                }
                Spacer(minLength: Constants.spacerMinLength)
            }
            if showTimeoutToast {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {}
                ToastTimeIsUpView(action: {
                    isTransitioning = true
                    questionViewModel.cancelAllTransitions()
                    withAnimation {
                        showTimeoutToast = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            contentState = .welcome
                            isLogoSmall = false
                            questionViewModel.resetQuiz()
                        }
                        isTransitioning = false
                    }
                })
                .padding(.top, Constants.toastTopPadding)
                .padding(.horizontal, Constants.toastHorizontalPadding)
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
    }
    private func startQuizWithFilters() {
        guard let categoryName = selectedCategory,
              let category = TriviaCategory.category(byName: categoryName),
              let difficultyName = selectedDifficulty,
              let difficulty = QuestionDifficulty(rawValue: difficultyName.lowercased()) else { return }
        Task {
            await questionViewModel.loadQuestions(category: category.id, difficulty: difficulty)
            withAnimation {
                contentState = .questions
            }
        }
    }
    private func startQuiz() {
        withAnimation {
            isLogoSmall = true
            contentState = .filters
        }
    }
        
    private func backToWelcome() {
        withAnimation {
            isLogoSmall = false
            contentState = .welcome
        }
    }
    
    //MARK: - Loader
    @ViewBuilder
    private func tryAgainText() -> some View {
        Text("Ошибка! Попробуйте ещё раз")
            .font(AppFontInter.bold.size(20))
            .foregroundStyle(.dQwhite)
            .padding(.top, 24)
    }
    
    //MARK: - HistoryButton
    private struct HistoryButton: View {
        var body: some View {
            Button(action: {}) {
                HStack(spacing: 0) {
                    Text("История")
                        .font(AppFontInter.semiBold.size(12))
                        .foregroundStyle(.dQpurple)
                    
                    Image("history_icon")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: Constants.historyIconSize,
                            height: Constants.historyIconSize
                        )
                        .foregroundStyle(.dQpurple)
                        .padding(.leading, Constants.historyIconLeadingPadding)
                }
                .padding(Constants.historyButtonPadding)
                .background(.dQwhite)
                .clipShape(RoundedRectangle(
                    cornerRadius: Constants.historyButtonCornerRadius
                ))
            }
        }
    }
    //MARK: - Welcome View
    private struct WelcomeView: View {
        let startQuiz: () -> Void
        
        var body: some View {
            VStack(spacing: 0) {
                Text("Добро пожаловать в DailyQuiz!")
                    .font(AppFontInter.bold.size(28))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding(.top, Constants.welcomeTitleTopPadding)
                
                Button(action: startQuiz) {
                    Text("НАЧАТЬ ВИКТОРИНУ")
                        .font(AppFontInter.black.size(16))
                        .foregroundStyle(.dQwhite)
                        .padding(
                            .vertical, Constants.buttonVerticalPadding
                        )
                        .padding(
                            .horizontal, Constants.buttonHorizontalPadding
                        )
                        .background(Color.dQpurple)
                        .clipShape(RoundedRectangle(
                            cornerRadius: Constants.buttonCornerRadius
                        ))
                }
                .padding(.top, Constants.buttonTopPadding)
                .padding(.bottom, Constants.buttonBottomPadding)
            }
            .frame(maxWidth: .infinity)
            .background(Color.dQwhite)
            .clipShape(RoundedRectangle(
                cornerRadius: Constants.welcomeViewCornerRadius
            ))
            .padding(.horizontal, Constants.welcomeViewHorizontalPadding)
        }
    }
    //MARK: - Loader
    private struct Loader: View {
        @State private var isRotating = false
        
        var body: some View {
            Image("loader_icon")
                .resizable()
                .scaledToFit()
                .frame(
                    width: Constants.loaderIconSize,
                    height: Constants.loaderIconSize
                )
                .foregroundStyle(.dQwhite)
                .rotationEffect(.degrees(isRotating ? 360 : 0))
                .animation(
                    .linear(duration: 3)
                    .repeatForever(autoreverses: false),
                    value: isRotating
                )
                .onAppear {
                    isRotating = true
                }
        }
    }
}

private extension MainPageView {
    
    // MARK: - Constants
    private enum Constants {
        // Layout
        static let topPadding: CGFloat = 46
        
        static let logoLargeSize: CGSize = CGSize(width: 300, height: 68)
        static let logoSmallSize: CGSize = CGSize(width: 180, height: 40)
        
        static let logoTopPadding: CGFloat = 114
        static let logoHorizontalPadding: CGFloat = 46
        
        static let logoSmallTopPadding: CGFloat = 35
        static let logoSmallHorizontalPadding: CGFloat = 106
        
        static let welcomeViewTopPadding: CGFloat = 40
        static let spacerMinLength: CGFloat = 20
        
        static let filterHorizontalPadding: CGFloat = 16
        static let filterTopPadding: CGFloat = 52
        
        static let questionsTopPadding: CGFloat = 40
        static let questionsHorizontalPadding: CGFloat = 26
        
        // History Button
        static let historyButtonCornerRadius: CGFloat = 24
        static let historyButtonPadding: CGFloat = 12
        static let historyIconSize: CGFloat = 16
        static let historyIconLeadingPadding: CGFloat = 12
        
        // Welcome View
        static let welcomeViewCornerRadius: CGFloat = 46
        static let welcomeViewHorizontalPadding: CGFloat = 16
        static let welcomeTitleTopPadding: CGFloat = 32
        static let buttonVerticalPadding: CGFloat = 15.5
        static let buttonHorizontalPadding: CGFloat = 51.5
        static let buttonCornerRadius: CGFloat = 16
        static let buttonTopPadding: CGFloat = 40
        static let buttonBottomPadding: CGFloat = 32
        
        //Loader
        static let loaderIconSize: CGFloat = 72
        static let loaderTopPadding: CGFloat = 120
        
        //Toast
        static let toastTopPadding: CGFloat = 305
        static let toastHorizontalPadding: CGFloat = 16
        
        //Result Page
        static let resultsTopPadding: CGFloat = 40
        static let resultsHorizontalPadding: CGFloat = 27
    }
}
#Preview {
    MainPageView()
}
