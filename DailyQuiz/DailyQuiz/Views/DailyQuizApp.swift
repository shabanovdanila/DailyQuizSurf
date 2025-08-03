//
//  DailyQuizApp.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 01.08.2025.
//

import SwiftUI

@main
struct DailyQuizApp: App {
    @StateObject private var navigationManager = NavigationManager()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationManager.path) {
                MainPageView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .history:
                            HistoryPageView(quizHistory: CoreDataManager.shared.fetchQuizHistory())
                        case .historyDetail(let quiz):
                            HistoryDetailView(quiz: quiz)
                        }
                    }
            }
            .environmentObject(navigationManager)
        }
    }
}
