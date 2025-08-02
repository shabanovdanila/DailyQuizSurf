//
//  QuestionView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

struct QuestionView: View {
    
    //MARK: - Constants enum
    enum Constants {
        //Timer
        static let timerHorizontalPadding: CGFloat = 24
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
    
    //MARK: - Properties
    let question: Question
    @State private var numberOfQuestion: Int = 1
    @State private var selectedAnswer: String?
    
    //MARK: - body
    var body: some View {
        ZStack {
            Color.dQpurple
                .ignoresSafeArea()
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    TimerView()
                        .padding(.top, Constants.timerTopPadding)
                        .padding(.horizontal, Constants.timerHorizontalPadding)
                    questionText(num: numberOfQuestion, text: question.question)
                    AnswersView(answers: question.answers, selectedAnswer: $selectedAnswer)
                        .padding(.top, Constants.answerTopPadding)
                        .padding(.horizontal, Constants.answerHorizontalPadding)
                    
                    NextButton(action: {}, numberOfQuestion: numberOfQuestion, isAnswerSelected: selectedAnswer != nil)
                        .padding(.top, Constants.nextTopPadding)
                        .padding(.bottom, Constants.nextBottomPadding)
                        .padding(.horizontal, Constants.nextHorizontalPadding)
                }
                .background(Color.dQwhite)
                .clipShape(RoundedRectangle(cornerRadius: 46))
                
                bottomText()
                    .padding(.top, Constants.bottomTextTopPadding)
            }
        }
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
                .padding(.top, Constants.questionTopPaddingUnderNumber)
        }
    }
    
    //MARK: - Bottom Text View
    @ViewBuilder
    private func bottomText() -> some View {
        Text("Вернуться к предыдущим вопросам нельзя")
            .font(AppFontInter.regular.size(10))
            .foregroundStyle(.dQwhite)
    }
    
    //MARK: - Answers View
    private struct AnswersView: View {
        
        let answers: [String]
        @Binding var selectedAnswer: String?
        
        var body: some View {
            VStack(spacing: 16) {
                ForEach(answers, id: \.self) { answer in
                    Button(action:  { selectedAnswer = answer }) {
                        HStack(spacing: 0) {
                            Image(selectedAnswer == answer ? "rb_selected" : "rb_default")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Constants.radioButtonSize, height: Constants.radioButtonSize)
                                .foregroundStyle(selectedAnswer == answer ? Color.DQdarkPurple: .black)
                                .padding(Constants.radioButtonPadding)
                            Text(answer)
                                .font(AppFontInter.regular.size(14))
                                .lineLimit(2)
                                .foregroundStyle(.black)
                            Spacer()
                        }
                        .background(selectedAnswer == answer ? Color.dQwhite : Color.dQgrayWhite)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selectedAnswer == answer ? Color.DQdarkPurple : Color.clear, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
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
                    .background(Color.dQpurple)
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
            .disabled(!isAnswerSelected)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
}

#Preview {
    QuestionView(question: Question(type: .multiple, difficulty: .hard, category: "asd", question: "Как переводится слово asdasd dasdas apple?", correctAnswer: "Яблоко", incorrectAnswers:
                                   ["Груша", "Ананас", "Апельсин"]))
}
