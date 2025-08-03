//
//  HistoryDetailCardView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 03.08.2025.
//

import SwiftUI
import CoreData

// MARK: - HistoryDetailCardView

struct HistoryDetailCardView: View {
    
    // MARK: - Properties
    
    let question: QuestionResult
    let numberOfQuestion: Int
    private var answers: [String] {
        guard let answers = (question.possibleAnswers?.array as? [AllAnswers]) else {
            return []
        }
        return answers.sorted { $0.index < $1.index }.compactMap { $0.answerText }
    }
    
    // MARK: - body
    
    var body: some View {
        CardView(question: question.questionText ?? "No question text",
                 answers: answers,
                 userAnswer: question.userAnswer ?? "No answer",
                 isCorrect: question.isCorrect,
                 numberOfQuestion: numberOfQuestion)
    }
}

// MARK: - CardView

private struct CardView: View {
    
    // MARK: - Properties
    
    let question: String
    let answers: [String]
    let userAnswer: String
    let isCorrect: Bool
    let numberOfQuestion: Int
    
    // MARK: - body
    
    var body: some View {
        VStack(spacing: 0) {
            numAndCheckMark
            questionText
                .padding(.top, Constants.questionTextTopPadding)
            AnswersViewHistory(answers: answers, userAnswer: userAnswer, isCorrect: isCorrect)
                .padding(.top, Constants.answersViewTopPadding)
        }
    }
    
    // MARK: - Private SubViews
    
    private var numAndCheckMark: some View {
        HStack(spacing: 0) {
            Text("Вопрос \(numberOfQuestion) из 5")
                .font(AppFontInter.bold.size(Constants.numberTextSize))
                .foregroundStyle(Color.DQgray)
            Spacer()
            Image(isCorrect ? "rb_right" : "rb_wrong")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Constants.checkMarkSize, height: Constants.checkMarkSize)
        }
    }
    
    private var questionText: some View {
        HStack {
            Spacer()
            Text(question)
                .multilineTextAlignment(.center)
                .font(AppFontInter.semiBold.size(Constants.questionTextSize))
                .foregroundStyle(.black)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
                .lineLimit(4)
            Spacer()
        }
    }
    
    // MARK: - CardView Constants Enum

    enum Constants {
        static let questionTextTopPadding: CGFloat = 24
        static let answersViewTopPadding: CGFloat = 24
        
        static let numberTextSize: CGFloat = 16
        static let checkMarkSize: CGFloat = 20
        static let questionTextSize: CGFloat = 18
    }
    
}

// MARK: - AnswersViewHistory

private struct AnswersViewHistory: View {
    
    // MARK: - Properties
    
    let answers: [String]
    let userAnswer: String
    let isCorrect: Bool
    
    // MARK: - body
    
    var body: some View {
        VStack(spacing: Constants.answersSpacing) {
            ForEach(answers, id: \.self) { answer in
                HStack(spacing: 0) {
                    getImageRB(for: answer)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Constants.radioButtonSize,
                               height: Constants.radioButtonSize)
                        .padding(Constants.radioButtonPadding)
                    
                    Text(answer)
                        .font(AppFontInter.regular.size(Constants.answerTextSize))
                        .lineLimit(Constants.answerLineLimit)
                        .foregroundStyle(.black)
                    
                    Spacer()
                }
                .background(getBackgroundColor(for: answer))
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.answerCornerRadius)
                        .stroke(getStrokeColor(for: answer),
                        lineWidth: Constants.answerBorderWidth)
                )
                .clipShape(RoundedRectangle(cornerRadius: Constants.answerCornerRadius))
            }
        }
    }
    
    // MARK: - Private Methods Styling
    
    private func getImageRB(for answer: String) -> Image {
        if (answer == userAnswer && isCorrect) {
            return Image("rb_right")
        } else if (answer == userAnswer && !isCorrect) {
            return Image("rb_wrong")
        }
        return Image("rb_default")
    }
    
    private func getStrokeColor(for answer: String) -> Color {
        if (answer == userAnswer && isCorrect) {
            return .DQgreen
        } else if (answer == userAnswer && !isCorrect) {
            return .DQred
        }
        return .clear
    }
    
    private func getBackgroundColor(for answer: String) -> Color {
        return userAnswer == answer ? .DQwhite : .DQgrayWhite
    }
    
    // MARK: - AnswersView Constants Enum
    
    enum Constants {
        static let answersSpacing: CGFloat = 16
        static let radioButtonSize: CGFloat = 20
        static let radioButtonPadding: CGFloat = 16
        static let answerTextSize: CGFloat = 14
        static let answerLineLimit: Int = 2
        static let answerCornerRadius: CGFloat = 16
        static let answerBorderWidth: CGFloat = 1
    }
}
