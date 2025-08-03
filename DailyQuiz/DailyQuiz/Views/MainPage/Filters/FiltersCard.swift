//
//  FiltersCard.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 03.08.2025.
//

import SwiftUI

//MARK: - Filters Card

struct FiltersCard: View {
    
    //MARK: - Properties

    let backAction: () -> Void
    let categoryAction: () -> Void
    let diffAction: () -> Void
    let nextButtonAction: () -> Void
    let selectedCategory: String?
    let selectedDifficulty: String?
    
    //MARK: - body

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("Почти готовы!")
                    .font(AppFontInter.bold.size(Constants.almostTextSize))
                    .foregroundStyle(.black)
                Text("Осталось выбрать категорию и сложность викторины")
                    .padding(.top, Constants.textTopPadding)
                    .font(AppFontInter.regular.size(Constants.almostUnderTextSize))
                    .multilineTextAlignment(.center)
            }
            .padding(.top, Constants.titleTopPadding)
            
            VStack(spacing: 0) {
                FilterButton(
                    action: categoryAction,
                    text: "Категория",
                    selectedValue: selectedCategory
                )
                FilterButton(
                    action: diffAction,
                    text: "Сложность",
                    selectedValue: selectedDifficulty
                )
                .padding(.top, Constants.diffTopPadding)
            }
            .frame(height: Constants.categoryHeight)
            .padding(.top, Constants.categoryTopPadding)
            .padding(.horizontal, Constants.categoryHorizontalPadding)
            
            Button(action: {
                if selectedCategory != nil && selectedDifficulty != nil {
                    nextButtonAction()
                }
            }) {
                if (selectedCategory != nil && selectedDifficulty != nil) {
                    Text("НАЧАТЬ ВИКТОРИНУ")
                        .font(AppFontInter.black.size(Constants.startButtonTextSize))
                        .foregroundStyle(Color.DQwhite)
                        .padding(.horizontal, Constants.nextButtonTextEnabledHorizontalPadding)
                        .padding(.vertical, Constants.nextButtonTextVerticalPadding)
                        .background(Color.DQpurple)
                } else {
                    Text("ДАЛЕЕ")
                        .font(AppFontInter.black.size(Constants.startButtonTextSize))
                        .foregroundStyle(Color.DQwhite)
                        .padding(.horizontal, Constants.nextButtonTextDisabledHorizontalPadding)
                        .padding(.vertical, Constants.nextButtonTextVerticalPadding)
                        .background(Color.DQgray)
                }
            }
            .disabled(selectedCategory == nil || selectedDifficulty == nil)
            .clipShape(RoundedRectangle(cornerRadius: Constants.nextButtonRadius))
            .padding(.top, Constants.nextButtonTopPadding)
            .padding(.bottom, Constants.nextButtonBottomPadding)
        }
        .background(Color.DQwhite)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cardRadius))
    }
    
    //MARK: - Filters Button

    private struct FilterButton: View {
        
        //MARK: - Properties

        let action: () -> Void
        let text: String
        let selectedValue: String?
        
        //MARK: - body

        var body: some View {
            Button(action: action) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(text)
                            .font(AppFontInter.bold.size(Constants.filterButtonTextSize))
                            .foregroundStyle(Color.DQdarkPurple)
                        
                        if let selectedValue {
                            Text(selectedValue)
                                .font(AppFontInter.regular.size(Constants.selectedValueSize))
                                .foregroundStyle(.black)
                                .padding(.top, Constants.selectedValueTopPadding)
                        }
                    }
                    .padding(.leading, Constants.filterButtonTextLeadingPadding)
                    
                    Spacer()
                    
                    Image("right_arrow")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.DQdarkPurple)
                        .frame(width: Constants.rightArrowIconSize,
                               height: Constants.rightArrowIconSize)
                        .padding(.trailing, Constants.filterButtonTextLeadingPadding)
                        .padding(.vertical, selectedValue != nil ? Constants.verticalSelected : Constants.filterButtonTextLeadingPadding)
                }
                .background(Color.DQgrayWhite)
                .clipShape(RoundedRectangle(cornerRadius: Constants.filterButtonRadius))
            }
        }
    }
    
}
private extension FiltersCard {
    enum Constants {
        //FiltersCard
        static let cardRadius: CGFloat = 46
        
        static let titleTopPadding: CGFloat = 32
        static let titleHorizontalPadding: CGFloat = 24
        
        static let nextButtonRadius: CGFloat = 16
        static let startButtonTextSize: CGFloat = 16
        static let categoryHeight: CGFloat = 152
        static let textTopPadding: CGFloat = 12
        static let bottomTextTopPadding: CGFloat = 12
        static let categoryTopPadding: CGFloat = 40
        static let diffTopPadding: CGFloat = 16
        static let categoryHorizontalPadding: CGFloat = 30
        static let nextButtonTopPadding: CGFloat = 39
        static let nextButtonHorizontalPadding: CGFloat = 40
        static let nextButtonBottomPadding: CGFloat = 32
        static let nextButtonTextVerticalPadding: CGFloat = 15.5
        static let nextButtonTextDisabledHorizontalPadding: CGFloat = 111
        static let nextButtonTextEnabledHorizontalPadding: CGFloat = 51.5
        static let rightArrowIconSize: CGFloat = 24
        
        static let almostTextSize: CGFloat = 24
        static let almostUnderTextSize: CGFloat = 16
        
        //Filter Button
        static let filterButtonTextSize: CGFloat = 16
        static let filterButtonTextLeadingPadding: CGFloat = 12
        static let selectedValueSize: CGFloat = 14
        static let selectedValueTopPadding: CGFloat = 8
        static let verticalSelected: CGFloat = 22
        static let filterButtonRadius: CGFloat = 16
    }
}
