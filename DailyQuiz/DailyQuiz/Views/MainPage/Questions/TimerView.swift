//
//  TimeView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

private let timerStep = 0.1

import SwiftUI

// MARK: - TimerView

struct TimerView: View {
    
    // MARK: - Properties

    private let totalDuration: TimeInterval = 10
    private let timer = Timer.publish(every: timerStep, on: .main, in: .common).autoconnect()
    
    @State private var progress = 0.0
    @State private var timeElapsed = 0.0
    @State private var finished = false
    
    var onTimeout: (() -> Void)?
    
    // MARK: - body

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(format(time: timeElapsed))
                    .font(AppFontInter.regular.size(Constants.textSize))
                    .foregroundStyle(Color.DQdarkPurple)
                
                Spacer()
                
                Text(format(time: totalDuration))
                    .font(AppFontInter.regular.size(Constants.textSize))
                    .foregroundStyle(Color.DQdarkPurple)
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: Constants.height)
                        .foregroundColor(Color.DQgray)
                    
                    Rectangle()
                        .frame(width: min(progress * geometry.size.width, geometry.size.width),
                               height: Constants.height)
                        .foregroundColor(Color.DQdarkPurple)
                        .animation(.linear, value: progress)
                }
                .cornerRadius(Constants.radius)
            }
            .frame(height: Constants.height)
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
    
    
    // MARK: - Private Methods

    private func format(time: Double) -> String {
        let elapsedMinutes = Int(time) / 60
        let elapsedSeconds = Int(time) % 60
        return String(format: "%02d:%02d", elapsedMinutes, elapsedSeconds)
    }
}


// MARK: - TimerView Extension

private extension TimerView {
    enum Constants {
        static let height: CGFloat = 8
        static let radius: CGFloat = 4
        static let textSize: CGFloat = 12
    }
}
