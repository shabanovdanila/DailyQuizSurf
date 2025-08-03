//
//  ToastTimeIsUpView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

// MARK: - ToastTimeIsUpView

struct ToastTimeIsUpView: View {
    
    // MARK: - Properties

    let action: () -> Void
    
    // MARK: - body

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("Время вышло!")
                    .font(AppFontInter.bold.size(Constants.timeIsUpTextSize))
                    .foregroundStyle(.black)
                    .padding(.top,  Constants.titleTopPadding)
                Text("Вы не успели завершить викторину. Попробуйте еще раз!")
                    .font(AppFontInter.regular.size(Constants.textAgainSize))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding(.top, Constants.textTopPadding)
            }
            .padding(.horizontal, Constants.textHorizontalPadding)
            
            AgainButton(action: action)
                .padding(.horizontal, Constants.buttonHorizontalPadding)
                .padding(.bottom, Constants.buttonBottomPadding)
                .padding(.top, Constants.buttonTopPadding)
        }
        .background(Color.DQwhite)
        .clipShape(RoundedRectangle(cornerRadius: Constants.toastRadius))
    }
}

// MARK: - AgainButton

struct AgainButton: View {
    
    // MARK: - Properties

    let action: () -> Void
    
    // MARK: - body

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text("НАЧАТЬ ЗАНОВО")
                    .font(AppFontInter.black.size(Constants.textAgainSize))
                    .foregroundStyle(Color.DQwhite)
                    .padding(.vertical, Constants.textAgainVerticalPadding)
                Spacer()
            }
            .background(Color.DQpurple)
            .clipShape(RoundedRectangle(cornerRadius: Constants.buttonAgainRadius))
        }
    }
}

// MARK: - Constants

private enum Constants {
    //Toast
    static let toastRadius: CGFloat = 46
    
    static let timeIsUpTextSize: CGFloat = 24
    static let tryAgainTextSize: CGFloat = 16
    
    static let titleTopPadding: CGFloat = 32
    static let textTopPadding: CGFloat = 12
    static let buttonTopPadding: CGFloat = 40
    static let buttonHorizontalPadding: CGFloat = 40
    static let buttonBottomPadding: CGFloat = 32
    static let textHorizontalPadding: CGFloat = 24
    
    //Again Button
    static let textAgainSize: CGFloat = 16
    static let textAgainVerticalPadding: CGFloat = 15.5
    static let buttonAgainRadius: CGFloat = 16
}

#Preview {
    ToastTimeIsUpView(action: {})
}
