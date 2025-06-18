
//
//  RecordButtonView.swift
//  WangHakka
//
//  Created by Shierly Anastasya Lie on 18/06/25.
//
import SwiftUI

struct Bar: Identifiable {
    var id: Int
    var height: CGFloat
}

class BarManager: ObservableObject {
    @Published var bars: [Bar] = []
    
    func updateBar(id: Int, newHeight: CGFloat) {
        if let index = bars.firstIndex(where: { $0.id == id }) {
            bars[index].height = newHeight
        }
    }
}

struct RecordButtonView: View {
    @StateObject private var barManager = BarManager()
    @State private var isRecording = false
    
    let barMaxHeight: CGFloat = 44
    let barWidth: CGFloat = 7
    let loopTime: Double = 1.5
    let numberOfBars = 5
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.backgroundButton)
                .shadow(color: .shadow, radius: 0, x: -3, y: 3)
                .onTapGesture {
                    toggleRecording()
                }
            
            HStack(alignment: .center, spacing: 3) {
                ForEach(barManager.bars) { bar in
                    Capsule()
                        .frame(width: barWidth, height: bar.height)
                        .foregroundStyle(LinearGradient(
                            colors: [Color.orangeWaves ?? .orange, Color.orange],
                            startPoint: .top,
                            endPoint: .bottom))
                }
            }
            .padding(20)
        }
        .onAppear {
            initializeBars()
            isRecording = true
            startRecording()
        }
    }
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
        isRecording.toggle()
    }
    
    func initializeBars() {
        for i in 0..<numberOfBars {
            barManager.bars.append(Bar(id: i, height: 0))
        }
    }
    
    func startRecording() {
        animateBars()
    }
    
    func stopRecording() {
        barManager.bars = barManager.bars.map { Bar(id: $0.id, height: 0) }
    }
    
    func animateBars() {
        let totalBars = barManager.bars.count
        
        for i in 0..<totalBars {
            let speedUp = (loopTime / 3) / Double(i + 1)
            let speedDown = speedUp * 3
            
            animateBar(id: i, speedUp: speedUp, speedDown: speedDown)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loopTime) {
            if self.isRecording {
                self.animateBars()
            }
        }
    }
    
    func animateBar(id: Int, speedUp: Double, speedDown: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + speedUp) {
            withAnimation(.linear(duration: speedUp)) {
                barManager.updateBar(id: id, newHeight: barMaxHeight)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + speedDown) {
                withAnimation(.linear(duration: speedDown)) {
                    barManager.updateBar(id: id, newHeight: 0)
                }
            }
        }
    }
}

#Preview {
    RecordButtonView()
}
