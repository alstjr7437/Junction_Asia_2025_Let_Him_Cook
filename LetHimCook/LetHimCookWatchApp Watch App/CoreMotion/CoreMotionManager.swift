//
//  CoreMotionManager.swift
//  LetHimCookWatchApp Watch App
//
//  Created by 길지훈 on 8/24/25.
//

import CoreMotion
import Foundation

final class CoreMotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    
    // @Published: 이 값들이 바뀌면 SwiftUI 뷰가 자동으로 업데이트됩니다.
    @Published var currentGesture: GestureType = .none
    @Published var accelerationData: String = "대기중..."
    
    /// '정지' 신호가 현재 활성화되었는지 여부를 추적하는 상태 변수입니다.
    @Published var isStopSignalActive: Bool = false
    
    // 제스처 유지를 위한 타이머
    private var gestureTimer: Timer?
    
    enum GestureType: String, CaseIterable {
        case none = "대기"
        case up = "위로"
        case down = "아래로"
        case stop = "정지"
    }
    
    init() {
        startMotionUpdates()
    }
    
    deinit {
        motionManager.stopAccelerometerUpdates()
        gestureTimer?.invalidate()
    }
    
    private func startMotionUpdates() {
        guard motionManager.isAccelerometerAvailable else {
            print("가속도계를 사용할 수 없습니다.")
            return
        }
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let data = data else { return }
            self.processAccelerometerData(data)
        }
    }
    
    private func processAccelerometerData(_ data: CMAccelerometerData) {
        let x = data.acceleration.x
        let y = data.acceleration.y
        let z = data.acceleration.z
        
        accelerationData = String(format: "X: %.2f\nY: %.2f\nZ: %.2f", x, y, z)
        
        // '정지' 신호가 활성화되어 있지 않을 때만 위/아래 움직임을 감지.
        // 이렇게 해야 '정지' 상태가 다른 움직임에 의해 풀리지 않게했음.
        if !isStopSignalActive {
            detectMotionGesture(x: x, y: y, z: z)
        }
    }
    
    private func detectMotionGesture(x: Double, y: Double, z: Double) {
        let threshold: Double = 2.0
        
        if y > threshold {
            // 새로운 제스처이거나 같은 제스처를 계속 유지하는 경우 모두 타이머 리셋
            setGestureWithTimer(.up)
            if currentGesture != .up {
                print("위로 제스처 감지")
            }
        } else if y < -threshold {
            // 새로운 제스처이거나 같은 제스처를 계속 유지하는 경우 모두 타이머 리셋
            setGestureWithTimer(.down)
            if currentGesture != .down {
                print("아래로 제스처 감지")
            }
        }
        // 임계값을 벗어나면 타이머가 자연스럽게 만료되어 .none으로 변경됨
    }
    
    /// 제스처를 설정하고 0.5초 후 자동으로 해제하는 메서드
    private func setGestureWithTimer(_ gesture: GestureType) {
        // 기존 타이머가 있다면 취소
        gestureTimer?.invalidate()
        
        // 제스처 설정
        currentGesture = gesture
        
        // 0.5초 후 대기 상태로 변경하는 타이머 시작
        gestureTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                if self?.currentGesture == gesture {
                    self?.currentGesture = .none
                }
            }
        }
    }
    
    /// '정지' 신호를 토글하는 메서드입니다. 뷰(버튼)에서 이 메서드를 호출합니다.
    func toggleStopSignal() {
        // isStopSignalActive 상태를 뒤집습니다. (true -> false, false -> true)
        isStopSignalActive.toggle()
        
        if isStopSignalActive {
            // '정지' 신호가 활성화되면
            currentGesture = .stop
            print("Stop signal sent!")
        } else {
            // '정지' 신호가 비활성화(취소)되면
            currentGesture = .none
            print("Stop signal canceled!")
        }
    }
}
