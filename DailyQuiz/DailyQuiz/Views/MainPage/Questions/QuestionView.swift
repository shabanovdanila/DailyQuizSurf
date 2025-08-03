//
//  QuestionView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

// MARK: - QuestionView

struct QuestionView: View {
    
    //MARK: - Properties
    
    let question: DisplayQuestion
    let onQuizComplete: (Int) -> Void
    
    @State private var shouldStopTimer = false
    @Binding var showTimeoutToast: Bool
    @State private var activeTransitionTask: Task<Void, Never>?
    
    @ObservedObject var viewModel: QuestionViewModel
    
    //MARK: - body
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                TimerView(shouldStopTimer: $shouldStopTimer, onTimeout: {
                    if !showTimeoutToast {
                        withAnimation {
                            showTimeoutToast = true
                        }
                    }})
                .padding(.top, Constants.timerTopPadding)
                .padding(.horizontal, Constants.timerHorizontalPadding)
                
                questionText(num: viewModel.currentQuestionIndex + 1, text: question.question)
                    .padding(.top, Constants.questionTopPadding)
                    .padding(.horizontal, Constants.questionHorizontalPadding)
                
                AnswersView(
                    selectedAnswer: $viewModel.selectedAnswer, answers: question.answers,
                    showAnswerFeedback: viewModel.showAnswerFeedback,
                    isCorrectAnswer: viewModel.isCorrectAnswer,
                    correctAnswer: question.correctAnswer
                )
                .padding(.top, Constants.answerTopPadding)
                .padding(.horizontal, Constants.answerHorizontalPadding)
                
                NextButton(
                    action: {
                        if viewModel.currentQuestionIndex == 4 {
                            shouldStopTimer = true
                        }
                        checkAnswerAndProceed()
                    },
                    numberOfQuestion: viewModel.currentQuestionIndex + 1,
                    isAnswerSelected: viewModel.selectedAnswer != nil,
                    needDisable: viewModel.showAnswerFeedback
                )
                .padding(.top, Constants.nextTopPadding)
                .padding(.bottom, Constants.nextBottomPadding)
                .padding(.horizontal, Constants.nextHorizontalPadding)
            }
            .background(Color.DQwhite)
            .clipShape(RoundedRectangle(cornerRadius: Constants.questionRadius))
            
            bottomText
                .padding(.top, Constants.bottomTextTopPadding)
        }
        .onChange(of: showTimeoutToast) {
            activeTransitionTask?.cancel()
            viewModel.cancelAllTransitions()
        }
        .disabled(viewModel.showAnswerFeedback || showTimeoutToast)
    }
    
    //MARK: - Question Text View
    @ViewBuilder
    private func questionText(num: Int, text: String) -> some View {
        VStack(spacing: 0) {
            Text("Вопрос \(num) из 5")
                .font(AppFontInter.bold.size(Constants.questionNumSize))
                .foregroundStyle(Color.DQlightPurple)
            Text(text)
                .multilineTextAlignment(.center)
                .font(AppFontInter.semiBold.size(Constants.questionTextSize))
                .foregroundStyle(.black)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, Constants.questionTopPaddingUnderNumber)
                .frame(maxWidth: .infinity)
                .lineLimit(4)
        }
    }
    
    //MARK: - Bottom Text View
    private var bottomText: some View {
        Text("Вернуться к предыдущим вопросам нельзя")
            .font(AppFontInter.regular.size(Constants.bottomTextSize))
            .foregroundStyle(Color.DQwhite)
    }
    
    // MARK: - Private Methods
    
    private func checkAnswerAndProceed() {
        guard !showTimeoutToast else { return }
        guard let selectedAnswer = viewModel.selectedAnswer else { return }
        
        viewModel.updateSelectedAnswer(for: question.id, answer: selectedAnswer)
        
        viewModel.submitAnswer()
        activeTransitionTask?.cancel()
        
        activeTransitionTask = Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            guard !Task.isCancelled && !viewModel.shouldCancelTransitions else { return }
            
            await MainActor.run {
                if !showTimeoutToast {
                    viewModel.moveToNextQuestion()
                    if viewModel.completeQuiz {
                        onQuizComplete(viewModel.score)
                    }
                }
            }
        }
    }
}

//MARK: - Next Button

private struct NextButton: View {
    
    var action: () ->  Void
    let numberOfQuestion: Int
    let isAnswerSelected: Bool
    let needDisable: Bool
    
    var body: some View {
        Button(action: action) {
            if (numberOfQuestion == 5) {
                HStack {
                    Spacer()
                    Text("ЗАВЕРШИТЬ")
                        .font(AppFontInter.black.size(16))
                        .foregroundStyle(Color.DQwhite)
                        .padding(.vertical, Constants.nextTextVerticalPadding)
                    Spacer()
                }
                .background(isAnswerSelected ? Color.DQpurple : Color.DQgray)
            } else {
                HStack {
                    Spacer()
                    Text("ДАЛЕЕ")
                        .font(AppFontInter.black.size(16))
                        .foregroundStyle(Color.DQwhite)
                        .padding(.vertical, Constants.nextTextVerticalPadding)
                    Spacer()
                }
                .background(isAnswerSelected ? Color.DQpurple : Color.DQgray)
            }
        }
        .disabled(!isAnswerSelected || needDisable)
        .clipShape(RoundedRectangle(cornerRadius: Constants.nextButtonRadius))
    }
}

//MARK: - Constants

private enum Constants {
    //Timer
    static let timerHorizontalPadding: CGFloat = 30
    static let timerTopPadding: CGFloat = 32
    
    //Question
    static let questionTopPadding: CGFloat = 38
    static let questionHorizontalPadding: CGFloat = 24
    static let questionTopPaddingUnderNumber: CGFloat = 24
    
    //Answers
    static let answerTopPadding: CGFloat = 24
    static let answerHorizontalPadding: CGFloat = 30
    
    //Next button
    static let nextTopPadding: CGFloat = 38
    static let nextBottomPadding: CGFloat = 32
    static let nextHorizontalPadding: CGFloat = 30
    static let nextTextVerticalPadding: CGFloat = 15.5
    static let nextButtonRadius: CGFloat = 16
    
    //Bottom text
    static let bottomTextTopPadding: CGFloat = 16
    static let bottomTextSize: CGFloat = 10
    
    //Question
    static let questionRadius: CGFloat = 46
    static let questionNumSize: CGFloat = 16
    static let questionTextSize: CGFloat = 18
}
