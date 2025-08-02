//
//  QuestionView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI


struct QuestionView: View {
    //MARK: - Properties
    let question: Question
    let onQuizComplete: (Int) -> Void
    
    @State private var numberOfQuestion: Int = 1
    @State private var selectedAnswer: String?
    @State private var showAnswerFeedback: Bool = false
    @State private var isCorrectAnswer: Bool = false
    @State private var needDisable: Bool = false
    @State private var shouldStopTimer = false
    @Binding var showTimeoutToast: Bool
    
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
                
                questionText(num: numberOfQuestion, text: question.question)
                    .padding(.top, Constants.questionTopPadding)
                    .padding(.horizontal, Constants.questionHorizontalPadding)
                
                AnswersView(
                    answers: question.answers,
                    selectedAnswer: $selectedAnswer,
                    showAnswerFeedback: showAnswerFeedback,
                    isCorrectAnswer: isCorrectAnswer,
                    correctAnswer: question.correctAnswer
                )
                .padding(.top, Constants.answerTopPadding)
                .padding(.horizontal, Constants.answerHorizontalPadding)
                
                NextButton(
                    action: {
                        if numberOfQuestion == 5 {
                            shouldStopTimer = true
                        }
                        checkAnswerAndProceed()
                    },
                    numberOfQuestion: numberOfQuestion,
                    isAnswerSelected: selectedAnswer != nil,
                    needDisable: needDisable
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
        .disabled(needDisable || showTimeoutToast)
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
                .lineLimit(3)
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
        guard let selectedAnswer else { return }
        
        isCorrectAnswer = selectedAnswer == question.correctAnswer
        showAnswerFeedback = true
        needDisable = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showAnswerFeedback = false
            needDisable = false
            goToNextQuestion()
        }
    }
        
    private func goToNextQuestion() {
        if numberOfQuestion < 5 {
            numberOfQuestion += 1
            selectedAnswer = nil
            // Здесь должна быть логика загрузки следующего вопроса
        } else {
            let score = calculateScore()
            onQuizComplete(score)
        }
    }
    private func calculateScore() -> Int {
           // логика подсчета очков
           return 4
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
