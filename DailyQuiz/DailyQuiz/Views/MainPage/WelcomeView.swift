//
//  WelcomeView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 03.08.2025.
//

import SwiftUI

//MARK: - Welcome View

struct WelcomeView: View {
    
    //MARK: - Welcome View

    let startQuiz: () -> Void
    
    //MARK: - body

    var body: some View {
        VStack(spacing: 0) {
            Text("Добро пожаловать в DailyQuiz!")
                .font(AppFontInter.bold.size(Constants.titleTextSize))
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
                .padding(.top, Constants.welcomeTitleTopPadding)
            
            Button(action: startQuiz) {
                Text("НАЧАТЬ ВИКТОРИНУ")
                    .font(AppFontInter.black.size(Constants.startTextSize))
                    .foregroundStyle(Color.DQwhite)
                    .padding(
                        .vertical, Constants.buttonVerticalPadding
                    )
                    .padding(
                        .horizontal, Constants.buttonHorizontalPadding
                    )
                    .background(Color.DQpurple)
                    .clipShape(RoundedRectangle(
                        cornerRadius: Constants.buttonCornerRadius
                    ))
            }
            .padding(.top, Constants.buttonTopPadding)
            .padding(.bottom, Constants.buttonBottomPadding)
        }
        .frame(maxWidth: .infinity)
        .background(Color.DQwhite)
        .clipShape(RoundedRectangle(
            cornerRadius: Constants.welcomeViewCornerRadius
        ))
        .padding(.horizontal, Constants.welcomeViewHorizontalPadding)
    }
}

//MARK: - Welcome View Extension

private extension WelcomeView {
    enum Constants {
        static let titleTextSize: CGFloat = 28
        static let startTextSize: CGFloat = 16
        
        static let welcomeViewCornerRadius: CGFloat = 46
        static let welcomeViewHorizontalPadding: CGFloat = 16
        static let welcomeTitleTopPadding: CGFloat = 32
        static let buttonVerticalPadding: CGFloat = 15.5
        static let buttonHorizontalPadding: CGFloat = 51.5
        static let buttonCornerRadius: CGFloat = 16
        static let buttonTopPadding: CGFloat = 40
        static let buttonBottomPadding: CGFloat = 32
    }
}
