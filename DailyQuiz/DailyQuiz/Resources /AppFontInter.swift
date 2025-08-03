//
//  AppFontInter.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 01.08.2025.
//
import SwiftUI

// MARK: - Custom Font Inter

enum AppFontInter: String {
    
    // MARK: - All Weights
    
    case black = "Inter-Black"
    case bold = "Inter-Bold"
    case extraBold = "Inter-ExtraBold"
    case extraLight = "Inter-ExtraLight"
    case light = "Inter-Light"
    case medium = "Inter-Medium"
    case regular = "Inter-Regular"
    case semiBold = "Inter-SemiBold"
    case thin = "Inter-Thin"
    
    // MARK: - Size Method
    
    func size(_ size: CGFloat) -> Font {
        return .custom(self.rawValue, size: size)
    }
}
