//
//  FiltersView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

struct FiltersView: View {
    
    private enum Constants {
        
        //FiltersCard
        static let titleTopPadding: CGFloat = 32
        static let titleHorizontalPadding: CGFloat = 24
        static let bottomTextTopPadding: CGFloat = 12
        static let categoryTopPadding: CGFloat = 40
        static let diffTopPadding: CGFloat = 16
        static let categoryHorizontalPadding: CGFloat = 30
        static let nextButtonTopPadding: CGFloat = 79
        static let nextButtonHorizontalPadding: CGFloat = 40
        static let nextButtonBottomPadding: CGFloat = 32
        static let nextButtonTextVerticalPadding: CGFloat = 15.5
        static let nextButtonTextHorizontalPadding: CGFloat = 111
        static let rightArrowIconSize: CGFloat = 24
    }
    //@StateObject private let viewModel:
    
    //MARK: - Properties
    let backAction: () -> Void
    
    
    var body: some View {
        VStack(spacing: 0) {
            FiltersCard(backAction: backAction, categoryAction: {}, diffAction: {}, nextButtonAction: {})
        }
    }
    
    private struct FiltersCard: View {
        
        let backAction: () -> Void
        let categoryAction: () -> Void
        let diffAction: () -> Void
        let nextButtonAction: () -> Void
        
        var body: some View {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("Почти готовы!")
                        .font(AppFontInter.bold.size(24))
                        .foregroundStyle(.black)
                    Text("Осталось выбрать категорию и сложность викторины")
                        .font(AppFontInter.regular.size(16))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, Constants.titleTopPadding)
                FilterButton(action: categoryAction, text: "Категория")
                    .padding(.top, Constants.categoryTopPadding)
                    .padding(.horizontal, Constants.categoryHorizontalPadding)
                FilterButton(action: diffAction, text: "Сложность")
                    .padding(.top, Constants.diffTopPadding)
                    .padding(.horizontal, Constants.categoryHorizontalPadding)
                Button(action: nextButtonAction) {
                    Text("ДАЛЕЕ")
                        .font(AppFontInter.black.size(16))
                        .foregroundStyle(.dQwhite)
                        .padding(.horizontal, Constants.nextButtonTextHorizontalPadding)
                        .padding(.vertical, Constants.nextButtonTextVerticalPadding)
                }
                .background(Color.dQgray)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.top, Constants.nextButtonTopPadding)
                .padding(.bottom, Constants.nextButtonBottomPadding)
                //
                Button(action: backAction) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Назад")
                    }
                    .foregroundColor(.dQpurple)
                }
                .padding(.top, 20)
            }
            .background(Color.dQwhite)
            .clipShape(RoundedRectangle(cornerRadius: 46))
        }
    }
    
    private struct FilterButton: View {
        
        let action: () -> Void
        let text: String
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 0) {
                    Text(text)
                        .font(AppFontInter.bold.size(16))
                        .foregroundStyle(.dQdarkPurple)
                        .padding(.leading, 12)
                    Spacer()
                    Image("right_arrow")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.dQdarkPurple)
                        .frame(width: Constants.rightArrowIconSize,
                               height: Constants.rightArrowIconSize)
                        .padding(.trailing, 12)
                        .padding(.vertical, 12)
                }
                .background(Color.dQgrayWhite)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

#Preview {
    FiltersView(backAction: {})
}
