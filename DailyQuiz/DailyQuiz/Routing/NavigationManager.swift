//
//  NavigationManager.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 03.08.2025.
//

import Foundation
import SwiftUI

// MARK: - Route Enum

enum AppRoute: Hashable {
    case history
    case historyDetail(QuizHistory)
}

// MARK: - Navigation Manager

final class NavigationManager: ObservableObject {
    
    // MARK: - Properties
    
    @Published var path = NavigationPath()
    
    // MARK: - Methods
    
    func push(route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
