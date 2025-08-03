//
//  TimerManager.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import Foundation

class TimerManager: ObservableObject {
    @Published var progress: CGFloat = 0.0
    @Published var timeElapsed = "00:00"
    private var timer: Timer?
    private var startTime: Date?
    private let totalDuration: TimeInterval = 2
    
    func startTimer(onTimeout: @escaping () -> Void) {
        stopTimer()
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateTimer(onTimeout: onTimeout)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimer(onTimeout: @escaping () -> Void) {
        guard let startTime = startTime else { return }
        
        let elapsed = Date().timeIntervalSince(startTime)
        progress = CGFloat(elapsed / totalDuration)
        
        let elapsedMinutes = Int(elapsed) / 60
        let elapsedSeconds = Int(elapsed) % 60
        timeElapsed = String(format: "%02d:%02d", elapsedMinutes, elapsedSeconds)

        if elapsed >= totalDuration {
            stopTimer()
            onTimeout()
        }
    }
}
