//
//  HistoryDetailCardView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 03.08.2025.
//

import SwiftUI
import CoreData

struct HistoryDetailCardView: View {
    let question: QuestionResult
    let numberOfQuestion: Int
    
    private var answers: [String] {
        guard let answers = (question.possibleAnswers?.array as? [AllAnswers]) else {
            return []
        }
        return answers.sorted { $0.index < $1.index }.compactMap { $0.answerText }
    }
    var body: some View {
        CardView(question: question.questionText ?? "No question text",
                 answers: answers,
                 userAnswer: question.userAnswer ?? "No answer",
                 isCorrect: question.isCorrect,
                 numberOfQuestion: numberOfQuestion)
    }
}

private struct CardView: View {
    let question: String
    let answers: [String]
    let userAnswer: String
    let isCorrect: Bool
    let numberOfQuestion: Int
    
    var body: some View {
        VStack(spacing: 0) {
            numAndCheckMark
            questionText
                .padding(.top, 24)
            AnswersView(answers: answers, userAnswer: userAnswer, isCorrect: isCorrect)
                .padding(.top, 24)
        }
    }
    
    private var numAndCheckMark: some View {
        HStack(spacing: 0) {
            Text("Вопрос \(numberOfQuestion) из 5")
                .font(AppFontInter.bold.size(16))
                .foregroundStyle(Color.DQgray)
            Spacer()
            Image(isCorrect ? "rb_right" : "rb_wrong")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
        }
    }
    private var questionText: some View {
        HStack {
            Spacer()
            Text(question)
                .multilineTextAlignment(.center)
                .font(AppFontInter.semiBold.size(18))
                .foregroundStyle(.black)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
                .lineLimit(4)
            Spacer()
        }
    }
}
private struct AnswersView: View {
    let answers: [String]
    let userAnswer: String
    let isCorrect: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(answers, id: \.self) { answer in
                HStack(spacing: 0) {
                    getImageRB(for: answer)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(16)
                    
                    Text(answer)
                        .font(AppFontInter.regular.size(14))
                        .lineLimit(2)
                        .foregroundStyle(.black)
                    
                    Spacer()
                }
                .background(getBackgroundColor(for: answer))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(getStrokeColor(for: answer), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
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
}
