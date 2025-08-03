//
//  LoaderView.swift
//  DailyQuiz
//
//  Created by Данила Шабанов on 03.08.2025.
//

import SwiftUI

struct LoaderView: View {
    @State private var isRotating: Bool = false
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        Image("loader_icon")
            .resizable()
            .scaledToFit()
            .frame(
                width: width,
                height: height
            )
            .foregroundStyle(.dQwhite)
            .rotationEffect(.degrees(isRotating ? 360 : 0))
            .animation(
                .linear(duration: 3)
                .repeatForever(autoreverses: false),
                value: isRotating
            )
            .onAppear {
                isRotating = true
            }
    }
}
