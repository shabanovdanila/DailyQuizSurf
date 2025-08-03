//
//  ResultsView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

// MARK: - ResultsView

struct ResultsView: View {
    
    // MARK: - Properties
    
    let resultScore: Int
    
    // MARK: - body
    
    var body: some View {
        VStack(spacing: 0) {
            StarsView(score: resultScore, starsSpacing: Constants.starsSpacing, starSize: Constants.starSize)
                .padding(.top, Constants.starsTopPadding)
                .padding(.horizontal, Constants.starsHorizontalPadding)
            
            resultScoreText
                .padding(.vertical, Constants.resultScoreVerticalPadding)
            
            titleAndText
                .padding(.horizontal, Constants.textHorizontalPadding)
        }
    }
    
    // MARK: - Private SubViews
    
    private var resultScoreText: some View {
        Text("\(resultScore) из 5")
            .font(AppFontInter.bold.size(Constants.resultScoreTextSize))
            .foregroundStyle(Color.DQyellow)
    }
    
    private var titleAndText: some View {
        VStack(spacing: 0) {
            Text(TitleText.forScore(score: resultScore).rawValue)
                .multilineTextAlignment(.center)
                .font(AppFontInter.bold.size(Constants.titleAndTextSize))
                .foregroundStyle(.black)
            Text(SubTitleText.forScore(score: resultScore).rawValue)
                .font(AppFontInter.regular.size(Constants.subTitleTextSize))
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
                .padding(.top, Constants.textTopPadding)
        }
    }
}

//MARK: - ResultsView Extension

private extension ResultsView {
    //MARK: - Constants Enum
    enum Constants {
        //Text
        static let resultScoreTextSize: CGFloat = 16
        static let titleAndTextSize: CGFloat = 24
        static let subTitleTextSize: CGFloat = 16
        
        //Stars
        static let starsTopPadding: CGFloat = 32
        static let starsHorizontalPadding: CGFloat = 24
        
        //Result
        static let resultScoreVerticalPadding: CGFloat = 24
        
        //Text
        static let textTopPadding: CGFloat = 12
        static let textHorizontalPadding: CGFloat = 22
        
        //Button
        static let buttonTopPadding: CGFloat = 64
        static let buttonBottomPadding: CGFloat = 32
        static let buttonHorizontalPadding: CGFloat = 30
        static let buttonTextVerticalPadding: CGFloat = 15.5
        
        static let starsSpacing: CGFloat = 8
        static let starSize: CGFloat = 52
    }
    
    //MARK: - Title Text Enum

    enum TitleText: String {
        case five = "Идеально!"
        case four = "Почти идеально!"
        case three = "Хороший результат!"
        case two = "Есть над чем поработать"
        case one = "Сложный вопрос?"
        case zero = "Бывает и так!"
        
        static func forScore(score: Int) -> Self {
            switch score {
            case 5: return .five
            case 4: return .four
            case 3: return .three
            case 2: return .two
            case 1: return .one
            case 0: return .zero
            default: return .zero
            }
        }
    }
    
    //MARK: - SubTitle Text Enum

    enum SubTitleText: String {
        case five = "5/5 — вы ответили на всё правильно. Это блестящий результат!"
        case four = "4/5 — очень близко к совершенству. Ещё один шаг!"
        case three = "3/5 — вы на верном пути. Продолжайте тренироваться!"
        case two = "2/5 — не расстраивайтесь, попробуйте ещё раз!"
        case one = "1/5 — иногда просто не ваш день. Следующая попытка будет лучше!"
        case zero = "0/5 — не отчаивайтесь. Начните заново и удивите себя!"
        
        static func forScore(score: Int) -> Self {
            switch score {
            case 5: return .five
            case 4: return .four
            case 3: return .three
            case 2: return .two
            case 1: return .one
            case 0: return .zero
            default: return .zero
            }
        }
    }
}
#Preview {
    ResultsView(resultScore: 4)
}
