//
//  ContentView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 01.08.2025.
//

import SwiftUI

// MARK: - Content State

private enum ContentState: Equatable {
    case welcome
    case filters
    case questions
    case results(score: Int)
}

// MARK: - MainPageView

struct MainPageView: View {
    
    //MARK: - Properties
    
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @StateObject private var questionViewModel = QuestionViewModel(apiService: TriviaApiServiceDefault())
    
    @State private var contentState: ContentState = .welcome
    @State private var isLogoSmall: Bool = false
    @State private var selectedCategory: String?
    @State private var selectedDifficulty: String?
    @State private var showTimeoutToast: Bool = false
    @State private var isTransitioning: Bool = false
    @State private var showBackButton: Bool = false
    
    //MARK: - body
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.DQpurple.ignoresSafeArea()
            if shouldShowBackButton {
                VStack {
                    HStack {
                        backButton
                        Spacer()
                    }
                    .padding(.horizontal, Constants.backButtonHorizontalPadding)
                    .padding(.top, Constants.backButtonTopPadding)
                    Spacer()
                }
            }
            VStack(spacing: 0) {
                if contentState == .welcome {
                    HistoryButton {
                        navigationManager.push(route: .history)
                    }
                    .padding(.top, Constants.topPadding)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
                }
                logoView
                
                if questionViewModel.isLoading {
                    LoaderView(width: Constants.loaderIconSize, height: Constants.loaderIconSize)
                        .padding(.top, Constants.loaderTopPadding)
                } else {
                    switch contentState {
                        
                    //MARK: - Welcome State
                        
                    case .welcome:
                        welcomeState
                        
                    //MARK: - Filters State
                        
                    case .filters:
                        filtersState
                        
                    //MARK: - Questions State
                        
                    case .questions:
                        if questionViewModel.currentQuestion != nil {
                            questionsState
                        }
                        
                    //MARK: - Results State
                        
                    case .results(let score):
                        resultsState(score: score)
                    }
                }
                if contentState == .welcome && questionViewModel.showError {
                    tryAgainText
                }
            }
            if showTimeoutToast {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {}
                    toast
            }
        }
        .disabled(questionViewModel.isLoading)
        .onChange(of: questionViewModel.showError) {
            withAnimation {
                contentState = .welcome
                isLogoSmall = false
            }
        }
    }
    
    // MARK: - Private SubViews
    
    private var logoView: some View{
        Image("logo_dq")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.DQwhite)
            .frame(
                width: isLogoSmall ? Constants.logoSmallSize.width : Constants.logoLargeSize.width,
                height: isLogoSmall ? Constants.logoSmallSize.height : Constants.logoLargeSize.height
            )
            .padding(.top, isLogoSmall ? Constants.logoSmallTopPadding : Constants.logoTopPadding)
            .animation(.smooth(duration: 0.5), value: isLogoSmall)
    }
    
    private var toast: some View {
        ToastTimeIsUpView(action: {
            let quizData = questionViewModel.prepareQuizData()
            CoreDataManager.shared.saveQuizResult(quizData: quizData)
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
    
    // MARK: - States
    
    private var welcomeState: some View {
        WelcomeView(startQuiz: startQuiz)
            .padding(.top, Constants.welcomeViewTopPadding)
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).animation(.easeOut(duration: 0.5)),
                removal: .move(edge: .bottom).combined(with: .opacity).animation(.easeIn(duration: 0.25))
            ))
    }
    
    private var filtersState: some View {
        FiltersView(backAction: backToWelcome, onStartQuiz: {
            startQuizWithFilters()
        }, selectedCategory: $selectedCategory, selectedDifficulty: $selectedDifficulty)
        .padding(.horizontal, Constants.filterHorizontalPadding)
        .padding(.top, Constants.filterTopPadding)
        .transition(.move(edge: .trailing))
    }
    
    @ViewBuilder
    private func resultsState(score: Int) -> some View {
        ResultsPageView(
            resultScore: score,
            action: {
                questionViewModel.resetQuiz()
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
    
    private var questionsState: some View {
        QuestionView(
            question: questionViewModel.currentQuestion!,
            onQuizComplete: { score in
                let quizData = questionViewModel.prepareQuizData()
                CoreDataManager.shared.saveQuizResult(quizData: quizData)
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
        .transition(.move(edge: .trailing))
    }
    
    //MARK: - Try Again Text
    
    private var tryAgainText: some View {
        Text("Ошибка! Попробуйте ещё раз")
            .font(AppFontInter.bold.size(Constants.tryAgainTextSize))
            .foregroundStyle(Color.DQwhite)
            .padding(.top, Constants.tryAgainTopPadding)
    }
    
    //MARK: - Back Button
    
    private var shouldShowBackButton: Bool {
        switch contentState {
        case .welcome: return false
        case .filters: return true
        case .questions: return questionViewModel.isFirstQuestion
        case .results: return false
        }
    }
    
    private var backButton: some View {
        Button(action: backToWelcome) {
            Image("back_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Constants.backButtonSize, height: Constants.backButtonSize)
                .foregroundColor(Color.DQwhite)
                .opacity(shouldShowBackButton ? 1 : 0)
        }
        .disabled(!shouldShowBackButton)
    }
    
    // MARK: - Private Methods
    
    private func startQuizWithFilters() {
        guard let categoryName = selectedCategory,
              let category = TriviaCategory.category(byName: categoryName),
              let difficultyName = selectedDifficulty,
              let difficulty = QuestionDifficulty.fromRussian(difficultyName) else { return }
        questionViewModel.resetQuiz()
        Task {
            await questionViewModel.loadQuestions(category: category.id, difficulty: difficulty)
            withAnimation {
                contentState = .questions
            }
        }
    }
    private func startQuiz() {
        questionViewModel.resetQuiz()
        withAnimation {
            isLogoSmall = true
            contentState = .filters
        }
    }
    
    private func backToWelcome() {
        questionViewModel.resetQuiz()
        withAnimation {
            isLogoSmall = false
            contentState = .welcome
        }
    }
    
    //MARK: - HistoryButton
    
    private struct HistoryButton: View {
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 0) {
                    Text("История")
                        .font(AppFontInter.semiBold.size(12))
                        .foregroundStyle(Color.DQpurple)
                    
                    Image("history_icon")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: Constants.historyIconSize,
                            height: Constants.historyIconSize
                        )
                        .foregroundStyle(Color.DQpurple)
                        .padding(.leading, Constants.historyIconLeadingPadding)
                }
                .padding(Constants.historyButtonPadding)
                .background(Color.DQwhite)
                .clipShape(RoundedRectangle(
                    cornerRadius: Constants.historyButtonCornerRadius
                ))
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
        
        //Loader
        static let loaderIconSize: CGFloat = 72
        static let loaderTopPadding: CGFloat = 305
        
        //Toast
        static let toastTopPadding: CGFloat = 305
        static let toastHorizontalPadding: CGFloat = 16
        
        //Result Page
        static let resultsTopPadding: CGFloat = 40
        static let resultsHorizontalPadding: CGFloat = 27
        
        // Back Button
        static let backButtonSize: CGFloat = 24
        static let backButtonHorizontalPadding: CGFloat = 26
        static let backButtonTopPadding: CGFloat = 43
        
        static let tryAgainTextSize: CGFloat = 20
        static let tryAgainTopPadding: CGFloat = 24
    }
}
#Preview {
    MainPageView()
}
