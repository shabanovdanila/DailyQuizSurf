//
//  TimeView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

private let timerStep = 0.1

import SwiftUI
import Combine

// MARK: - TimerView

struct TimerView: View {
    
    // MARK: - Properties

    private let totalDuration: TimeInterval = 5 * 60
    @State private var timer = Timer.publish(every: timerStep, on: .main, in: .common)
    @State private var connectedTimer: Cancellable? = nil
    @Binding var shouldStopTimer: Bool

    @State private var progress = 0.0
    @State private var timeElapsed = 0.0
    @State private var finished = false
    
    var onTimeout: (() -> Void)?
    
    // MARK: - body

    var body: some View {
        VStack(spacing: Constants.height) {
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
        }.onAppear {
            instantiateTimer()
        }.onDisappear {
            cancelTimer()
            resetTimer()
        }.onReceive(timer) { _ in
            if timeElapsed < totalDuration {
                timeElapsed += timerStep
                progress = timeElapsed / totalDuration
            } else if !finished {
                cancelTimer()
                onTimeout?()
                finished = true
            }
        }.onChange(of: shouldStopTimer) {
            cancelTimer()
        }
    }
    
    // MARK: - Private Methods

    func instantiateTimer() {
        self.timer = Timer.publish(every: timerStep, on: .main, in: .common)
        self.connectedTimer = self.timer.connect()
    }

    func cancelTimer() {
        self.connectedTimer?.cancel()
        return
    }

    func resetTimer() {
        self.progress = 0.0
        self.timeElapsed = 0.0
    }

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
