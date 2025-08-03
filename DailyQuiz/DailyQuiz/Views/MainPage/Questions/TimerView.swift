//
//  TimeView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

private let timerStep = 0.1

import SwiftUI

struct TimerView: View {
    private let totalDuration: TimeInterval = 300
    private let timer = Timer.publish(every: timerStep, on: .main, in: .common).autoconnect()
    
    @State private var progress = 0.0
    @State private var timeElapsed = 0.0
    @State private var finished = false
    
    var onTimeout: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(format(time: timeElapsed))
                    .font(AppFontInter.regular.size(12))
                    .foregroundStyle(.dQdarkPurple)
                
                Spacer()
                
                Text(format(time: totalDuration))
                    .font(AppFontInter.regular.size(12))
                    .foregroundStyle(.dQdarkPurple)
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 8)
                        .foregroundColor(.dQgray)
                    
                    Rectangle()
                        .frame(width: min(progress * geometry.size.width, geometry.size.width),
                               height: 8)
                        .foregroundColor(.dQdarkPurple)
                        .animation(.linear, value: progress)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
        }.onReceive(timer) { _ in
            if timeElapsed < totalDuration {
                timeElapsed += timerStep
                progress = timeElapsed / totalDuration
            } else if !finished {
                timer.upstream.connect().cancel()
                onTimeout?()
                finished = true
            }
        }
    }
    
    private func format(time: Double) -> String {
        let elapsedMinutes = Int(time) / 60
        let elapsedSeconds = Int(time) % 60
        return String(format: "%02d:%02d", elapsedMinutes, elapsedSeconds)
    }
}
