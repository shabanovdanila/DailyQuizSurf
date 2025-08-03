//
//  NavigationManager.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 03.08.2025.
//

import Foundation
import SwiftUI

enum AppRoute: Hashable {
    case history
    case historyDetail(QuizHistory)
}

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(route: AppRoute) {
        print("pusign")
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
