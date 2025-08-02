//
//  StarsView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

struct StarsView: View {
    //MARK: - Constants Enum
    private enum Constants {
        static let starsSpacing: CGFloat = 8
        static let starSize: CGFloat = 52
    }
    
    //MARK: - Properties
    let score: Int
    let maxScore: Int = 5
    
    //MARK: - body
    var body: some View {
        HStack(spacing: Constants.starsSpacing) {
            ForEach(0..<maxScore, id: \.self) { index in
                Image(index < score ? "star_icon_active" : "star_icon_inactive")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Constants.starSize, height: Constants.starSize)
            }
        }
    }
}
