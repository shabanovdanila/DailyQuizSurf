//
//  ContentView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 01.08.2025.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Constants
    private enum Constants {
        // Layout
        static let topPadding: CGFloat = 46
        static let logoTopPadding: CGFloat = 114
        static let logoHorizontalPadding: CGFloat = 46
        static let welcomeViewTopPadding: CGFloat = 40
        static let spacerMinLength: CGFloat = 20
        
        // History Button
        static let historyButtonCornerRadius: CGFloat = 24
        static let historyButtonPadding: CGFloat = 12
        static let historyIconSize: CGFloat = 16
        static let historyIconLeadingPadding: CGFloat = 12
        
        // Welcome View
        static let welcomeViewCornerRadius: CGFloat = 46
        static let welcomeViewHorizontalPadding: CGFloat = 16
        static let welcomeTitleTopPadding: CGFloat = 32
        static let buttonVerticalPadding: CGFloat = 15.5
        static let buttonHorizontalPadding: CGFloat = 51.5
        static let buttonCornerRadius: CGFloat = 16
        static let buttonTopPadding: CGFloat = 40
        static let buttonBottomPadding: CGFloat = 32
    }
    
    //MARK: - body
    var body: some View {
        ZStack {
            Color.dQpurple.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HistoryButton()
                    .padding(.top, Constants.topPadding)
                
                Image("logo_dq")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.dQwhite)
                    .padding(.top, Constants.logoTopPadding)
                    .padding(.horizontal, Constants.logoHorizontalPadding)
                
                WelcomeView()
                    .padding(.top, Constants.welcomeViewTopPadding)
                
                Spacer(minLength: Constants.spacerMinLength)
            }
        }
    }
    //MARK: - HistoryButton
    private struct HistoryButton: View {
        var body: some View {
            Button(action: {}) {
                HStack(spacing: 0) {
                    Text("История")
                        .font(AppFontInter.semiBold.size(12))
                        .foregroundStyle(.dQpurple)
                    
                    Image("history_icon")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: Constants.historyIconSize,
                            height: Constants.historyIconSize
                        )
                        .foregroundStyle(.dQpurple)
                        .padding(.leading, Constants.historyIconLeadingPadding)
                }
                .padding(Constants.historyButtonPadding)
                .background(.dQwhite)
                .clipShape(RoundedRectangle(
                    cornerRadius: Constants.historyButtonCornerRadius
                ))
            }
        }
    }
    //MARK: - Welcome View
    private struct WelcomeView: View {
        var body: some View {
            VStack(spacing: 0) {
                Text("Добро пожаловать в DailyQuiz!")
                    .font(AppFontInter.bold.size(28))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding(.top, Constants.welcomeTitleTopPadding)
                
                Button(action: {}) {
                    Text("НАЧАТЬ ВИКТОРИНУ")
                        .font(AppFontInter.black.size(16))
                        .foregroundStyle(.dQwhite)
                        .padding(
                            .vertical, Constants.buttonVerticalPadding
                        )
                        .padding(
                            .horizontal, Constants.buttonHorizontalPadding
                        )
                        .background(Color.dQpurple)
                        .clipShape(RoundedRectangle(
                            cornerRadius: Constants.buttonCornerRadius
                        ))
                }
                .padding(.top, Constants.buttonTopPadding)
                .padding(.bottom, Constants.buttonBottomPadding)
            }
            .frame(maxWidth: .infinity)
            .background(Color.dQwhite)
            .clipShape(RoundedRectangle(
                cornerRadius: Constants.welcomeViewCornerRadius
            ))
            .padding(.horizontal, Constants.welcomeViewHorizontalPadding)
        }
    }
}

#Preview {
    ContentView()
}
