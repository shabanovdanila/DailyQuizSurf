//
//  ToastView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 03.08.2025.
//

import SwiftUI

struct ToastDeletedView: View {
    
    private enum Constants {
        static let titleTopPadding: CGFloat = 32
        static let textTopPadding: CGFloat = 12
        static let buttonTopPadding: CGFloat = 40
        static let buttonHorizontalPadding: CGFloat = 40
        static let buttonBottomPadding: CGFloat = 32
        static let textHorizontalPadding: CGFloat = 24
    }
    
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("Попытка удалена")
                    .font(AppFontInter.bold.size(24))
                    .foregroundStyle(.black)
                    .padding(.top,  Constants.titleTopPadding)
                Text("Вы можете пройти викторину снова, когда будете готовы.")
                    .font(AppFontInter.regular.size(16))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding(.top, Constants.textTopPadding)
            }
            .padding(.horizontal, Constants.textHorizontalPadding)
            
            okButton(action: action)
                .padding(.horizontal, Constants.buttonHorizontalPadding)
                .padding(.bottom, Constants.buttonBottomPadding)
                .padding(.top, Constants.buttonTopPadding)
        }
        .background(Color.DQwhite)
        .clipShape(RoundedRectangle(cornerRadius: 46))
    }
}

private struct okButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text("Хорошо")
                    .font(AppFontInter.black.size(16))
                    .foregroundStyle(Color.DQwhite)
                    .padding(.vertical, 15.5)
                Spacer()
            }
            .background(Color.DQpurple)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
