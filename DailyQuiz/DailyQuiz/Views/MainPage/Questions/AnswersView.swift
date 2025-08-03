//
//  AnswersView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 03.08.2025.
//

import SwiftUI

//MARK: - Answers View

struct AnswersView: View {
    
    //MARK: - Properties
    
    @Binding var selectedAnswer: String?
    
    let answers: [String]
    let showAnswerFeedback: Bool
    let isCorrectAnswer: Bool
    let correctAnswer: String
    
    //MARK: - body
    
    var body: some View {
        VStack(spacing: Constants.spacing) {
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
                            .font(AppFontInter.regular.size(Constants.answerSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.black)
                        
                        Spacer()
                    }
                    .background(getBackgroundColor(for: answer))
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.cardRadius)
                            .stroke(getBorderColor(for: answer), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cardRadius))
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
        return selectedAnswer == answer ? .DQwhite : .DQgrayWhite
    }
    
    private func getBorderColor(for answer: String) -> Color {
        if showAnswerFeedback {
            if answer == selectedAnswer && selectedAnswer == correctAnswer {
                return .DQgreen
            } else if answer == selectedAnswer && answer != correctAnswer {
                return .DQred
            }
        }
        return selectedAnswer == answer ? .DQdarkPurple : .clear
    }
}

//MARK: - AnswersView extension

private extension AnswersView {
    enum Constants {
        static let radioButtonSize: CGFloat = 20
        static let radioButtonPadding: CGFloat = 16
        static let spacing: CGFloat = 16
        static let answerSize: CGFloat = 14
        static let cardRadius: CGFloat = 16
    }
}

