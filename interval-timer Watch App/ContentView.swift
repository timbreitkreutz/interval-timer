import SwiftUI
import WatchKit

struct ContentView: View {
    @State private var isRunning = false
    @State private var totalSeconds: Int = 0
    @State private var redDuration: Int = 20
    @State private var blueDuration: Int = 10
    @State private var isRedPhase: Bool = true
    @State private var timer: Timer?
    
    var displayTime: String {
        let mins = totalSeconds / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Red Timer
            VStack(spacing: 4) {
                Picker("Red", selection: $redDuration) {
                    ForEach([5, 10, 15, 20, 30, 45, 60], id: \.self) { sec in
                        Text("\(sec)s").tag(sec)
                    }
                }
                .pickerStyle(.wheel)
                .disabled(isRunning)
                .frame(height: 50)
            }
            .foregroundColor(.red)
            
            if isRunning && isRedPhase {
                Text(displayTime)
                    .font(.system(size: 40, weight: .bold))
                    .monospacedDigit()
                    .foregroundColor(.red)
            }
            
            // Blue Timer
            VStack(spacing: 4) {
                Picker("Blue", selection: $blueDuration) {
                    ForEach([5, 10, 15, 20, 30, 45, 60], id: \.self) { sec in
                        Text("\(sec)s").tag(sec)
                    }
                }
                .pickerStyle(.wheel)
                .disabled(isRunning)
                .frame(height: 50)
            }
            .foregroundColor(.blue)
            
            if isRunning && !isRedPhase {
                Text(displayTime)
                    .font(.system(size: 40, weight: .bold))
                    .monospacedDigit()
                    .foregroundColor(.blue)
            }
            
            // Start/Stop Button
            Button(action: toggleTimer) {
                Text(isRunning ? "Stop" : "Start")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(isRunning ? .red : .green)
        }
        .padding()
    }
    
    func toggleTimer() {
        isRunning.toggle()
        if isRunning {
            isRedPhase = true
            totalSeconds = redDuration
            startTimer()
        } else {
            timer?.invalidate()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if totalSeconds > 0 {
                totalSeconds -= 1
            } else {
                buzz()
                switchPhase()
            }
        }
    }
    
    func switchPhase() {
        isRedPhase.toggle()
        totalSeconds = isRedPhase ? redDuration : blueDuration
    }
    
    func buzz() {
        WKInterfaceDevice.current().play(.notification)
    }
}

#Preview {
    ContentView()
}
