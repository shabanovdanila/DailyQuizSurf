//
//  TimeView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 02.08.2025.
//

import SwiftUI

struct TimerView: View {
    @State private var progress: CGFloat = 0.0
    @State private var timeElapsed = "00:00"
    @State private var startTime: Date?
    
    private let totalDuration: TimeInterval = 300
    private let timeRemaining = "05:00"
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(timeElapsed)
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
                        .opacity(0.3)
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
        }
        .padding()
        .onReceive(timer) { _ in
            updateTimer()
        }
        .onAppear {
            startTime = Date()
        }
    }
    
    private func updateTimer() {
        guard let startTime = startTime else { return }
        
        let elapsed = Date().timeIntervalSince(startTime)
        progress = CGFloat(elapsed / totalDuration)
        
        let elapsedMinutes = Int(elapsed) / 60
        let elapsedSeconds = Int(elapsed) % 60
        timeElapsed = String(format: "%02d:%02d", elapsedMinutes, elapsedSeconds)

        if elapsed >= totalDuration {
            timer.upstream.connect().cancel()
        }
    }
}

#Preview {
    TimerView()
}
