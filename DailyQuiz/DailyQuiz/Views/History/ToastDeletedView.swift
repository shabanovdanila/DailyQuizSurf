//
//  ToastView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 03.08.2025.
//

import SwiftUI

// MARK: - ToastDeletedView

struct ToastDeletedView: View {
    
    // MARK: - Properties
    
    let action: () -> Void
    
    // MARK: - body
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("Попытка удалена")
                    .font(AppFontInter.bold.size(Constants.titleTextSize))
                    .foregroundStyle(.black)
                    .padding(.top,  Constants.titleTopPadding)
                Text("Вы можете пройти викторину снова, когда будете готовы.")
                    .font(AppFontInter.regular.size(Constants.subTextSize))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding(.top, Constants.textTopPadding)
            }
            .padding(.horizontal, Constants.textHorizontalPadding)
            
            okButton
                .padding(.horizontal, Constants.buttonHorizontalPadding)
                .padding(.bottom, Constants.buttonBottomPadding)
                .padding(.top, Constants.buttonTopPadding)
        }
        .background(Color.DQwhite)
        .clipShape(RoundedRectangle(cornerRadius: Constants.viewRadius))
    }
    
    // MARK: - Private SubViews
    
    private var okButton:  some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text("Хорошо")
                    .font(AppFontInter.black.size(Constants.buttonTextSize))
                    .foregroundStyle(Color.DQwhite)
                    .padding(.vertical, Constants.buttonVerticalPadding)
                Spacer()
            }
            .background(Color.DQpurple)
            .clipShape(RoundedRectangle(cornerRadius: Constants.buttonRadius))
        }
    }
}

// MARK: - ToastDeletedView Extension

private extension ToastDeletedView {
    enum Constants {
        //Layout
        static let titleTopPadding: CGFloat = 32
        static let textTopPadding: CGFloat = 12
        static let buttonTopPadding: CGFloat = 40
        static let buttonHorizontalPadding: CGFloat = 40
        static let buttonBottomPadding: CGFloat = 32
        static let textHorizontalPadding: CGFloat = 24
        //Size
        static let titleTextSize: CGFloat = 24
        static let subTextSize: CGFloat = 16
        static let viewRadius: CGFloat = 46
        //Button
        static let buttonTextSize: CGFloat = 16
        static let buttonVerticalPadding: CGFloat = 15.5
        static let buttonRadius: CGFloat = 16
        
    }
}
