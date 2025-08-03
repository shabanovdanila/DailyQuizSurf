//
//  QuestionView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI


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
                TimerView(onTimeout: {
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
                    answers: question.answers,
                    selectedAnswer: $viewModel.selectedAnswer,
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
            .background(Color.dQwhite)
            .clipShape(RoundedRectangle(cornerRadius: 46))
            
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
                .font(AppFontInter.bold.size(16))
                .foregroundStyle(.dQlightPurple)
            Text(text)
                .multilineTextAlignment(.center)
                .font(AppFontInter.semiBold.size(18))
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
            .font(AppFontInter.regular.size(10))
            .foregroundStyle(.dQwhite)
    }
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
    //MARK: - Answers View
private struct AnswersView: View {
    let answers: [String]
    @Binding var selectedAnswer: String?
    let showAnswerFeedback: Bool
    let isCorrectAnswer: Bool
    let correctAnswer: String
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(answers, id: \.self) { answer in
                Button(action: {
                    if !showAnswerFeedback {
                        selectedAnswer = answer
                    }
                }) {
                    HStack(spacing: 0) {
                        getRadioButtonImage(for: answer)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Constants.radioButtonSize, height: Constants.radioButtonSize)
                            .padding(Constants.radioButtonPadding)
                        
                        Text(answer)
                            .font(AppFontInter.regular.size(14))
                            .lineLimit(2)
                            .foregroundStyle(.black)
                        
                        Spacer()
                    }
                    .background(getBackgroundColor(for: answer))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(getBorderColor(for: answer), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(showAnswerFeedback)
            }
        }
    }
    
    //MARK: - Styling Radio Button
    private func getRadioButtonImage(for answer: String) -> Image {
        if showAnswerFeedback {
            if isCorrectAnswer && answer == correctAnswer {
                return Image("rb_right")
            } else if !isCorrectAnswer && answer == selectedAnswer {
                return Image("rb_wrong")
            }
        }
        return selectedAnswer == answer ? Image("rb_selected") : Image("rb_default")
    }
    
    private func getBackgroundColor(for answer: String) -> Color {
        return selectedAnswer == answer ? .dQwhite : .dQgrayWhite
    }
    
    private func getBorderColor(for answer: String) -> Color {
        if showAnswerFeedback {
            if answer == selectedAnswer && selectedAnswer == correctAnswer {
                return .dQgreen
            } else if answer == selectedAnswer && answer != correctAnswer {
                return .dQred
            }
        }
        return selectedAnswer == answer ? .dQdarkPurple : .clear
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
                        .foregroundStyle(.dQwhite)
                        .padding(.vertical, Constants.nextTextVerticalPadding)
                    Spacer()
                }
                .background(isAnswerSelected ? Color.dQpurple : Color.dQgray)
            } else {
                HStack {
                    Spacer()
                    Text("ДАЛЕЕ")
                        .font(AppFontInter.black.size(16))
                        .foregroundStyle(.dQwhite)
                        .padding(.vertical, Constants.nextTextVerticalPadding)
                    Spacer()
                }
                .background(isAnswerSelected ? Color.dQpurple : Color.dQgray)
            }
        }
        .disabled(!isAnswerSelected || needDisable)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
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
    static let nextTopPadding: CGFloat = 67
    static let nextBottomPadding: CGFloat = 32
    static let nextHorizontalPadding: CGFloat = 30
    static let nextTextVerticalPadding: CGFloat = 15.5
    
    //Bottom text
    static let bottomTextTopPadding: CGFloat = 16
    
    //Radio button
    static let radioButtonSize: CGFloat = 20
    static let radioButtonPadding: CGFloat = 16
}
//#Preview {
//    QuestionView(question: Question(type: .multiple, difficulty: .hard, category: "asd", question: "Как переводится слово asdasd dasdas apple?", correctAnswer: "Яблоко", incorrectAnswers:
//                                   ["Груша", "Ананас", "Апельсин"]))
//}
