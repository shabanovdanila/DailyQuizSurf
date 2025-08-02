//
//  TimeView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var timerManager = TimerManager()
    @Binding var shouldStopTimer: Bool
    private let timeRemaining = "05:00"
    
    var onTimeout: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(timerManager.timeElapsed)
                    .font(AppFontInter.regular.size(12))
                    .foregroundStyle(.dQdarkPurple)
                
                Spacer()
                
                Text(timeRemaining)
                    .font(AppFontInter.regular.size(12))
                    .foregroundStyle(.dQdarkPurple)
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 8)
                        .foregroundColor(.dQgray)
                    
                    Rectangle()
                        .frame(width: min(timerManager.progress * geometry.size.width, geometry.size.width),
                               height: 8)
                        .foregroundColor(.dQdarkPurple)
                        .animation(.linear, value: timerManager.progress)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
        }
        .onAppear {
            timerManager.startTimer(onTimeout: {
                onTimeout?()
            })
        }
        .onDisappear {
            timerManager.stopTimer()
        }
        .onChange(of: shouldStopTimer) {
            timerManager.stopTimer()
        }
    }
}


//#Preview {
//    TimerView()
//}
