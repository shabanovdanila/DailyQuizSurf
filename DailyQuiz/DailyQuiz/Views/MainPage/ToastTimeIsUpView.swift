//
//  ToastTimeIsUpView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

struct ToastTimeIsUpView: View {
    
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
                Text("Время вышло!")
                    .font(AppFontInter.bold.size(24))
                    .foregroundStyle(.black)
                    .padding(.top,  Constants.titleTopPadding)
                Text("Вы не успели завершить викторину. Попробуйте еще раз!")
                    .font(AppFontInter.regular.size(16))
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
        .background(.dQwhite)
        .clipShape(RoundedRectangle(cornerRadius: 46))
    }
}

struct AgainButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text("НАЧАТЬ ЗАНОВО")
                    .font(AppFontInter.black.size(16))
                    .foregroundStyle(.dQwhite)
                    .padding(.vertical, 15.5)
                Spacer()
            }
            .background(.dQpurple)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    ToastTimeIsUpView(action: {})
}
