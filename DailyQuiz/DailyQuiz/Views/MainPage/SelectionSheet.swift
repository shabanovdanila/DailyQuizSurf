//
//  SelectionSheet.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

struct SelectionSheet: View {
    
    private enum Constants {
        static let titleTopPadding: CGFloat = 25
        static let titleHorizontalPadding: CGFloat = 16.5
        static let firstLineTopPadding: CGFloat = 25
        static let linesTopPadding: CGFloat = 30
        static let bottomPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 35
    }
    
    let title: String
    let items: [String]
    @Binding var selectedItem: String?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(AppFontInter.bold.size(24))
                .foregroundStyle(.dQdarkPurple)
                .padding(.top, Constants.titleTopPadding)
                .padding(.horizontal, Constants.titleHorizontalPadding)
            
            LazyVStack(alignment: .leading, spacing: Constants.linesTopPadding) {
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        selectedItem = item
                        dismiss()
                    }) {
                        HStack(spacing: 0) {
                            if (selectedItem == item) {
                                Text(item)
                                    .font(AppFontInter.bold.size(16))
                                    .foregroundStyle(.dQdarkPurple)
                                Spacer()
                                Image(systemName: "checkmark")
                                    .foregroundColor(.dQpurple)
                            } else {
                                Text(item)
                                    .font(AppFontInter.regular.size(16))
                                    .foregroundStyle(.dQdarkPurple)
                            }
                        }
                        .padding(.horizontal, Constants.titleHorizontalPadding)
                    }
                }
            }
            .padding(.top, Constants.firstLineTopPadding)
        }
        .background(Color.dQwhite)
        .presentationDetents([.height(calculateSheetHeight())])
        .presentationDragIndicator(.visible)
    }
    
    private func calculateSheetHeight() -> CGFloat {
        let titleBlockHeight: CGFloat = 24 + Constants.firstLineTopPadding
        let itemsHeight = CGFloat(items.count) * (16 + Constants.linesTopPadding)
        let lastItemPadding: CGFloat = 16
        let bottomPadding: CGFloat = Constants.bottomPadding
        
        return titleBlockHeight + itemsHeight + lastItemPadding + bottomPadding
    }
}
