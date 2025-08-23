//
//  GestureOverlayManager.swift
//  LetHimCook
//
//  Created by 길지훈 on 8/24/25.
//

import SwiftUI
import UIKit

final class GestureOverlayManager: ObservableObject {
    static let shared = GestureOverlayManager()
    
    @Published var currentGesture: GestureType = .none
    
    enum GestureType: String, CaseIterable {
        case none = "없음"
        case stop = "정지"
        case boomUp = "붐 올리기"
        case boomDown = "붐 내리기"
    }
    
    private var gestureTimer: Timer?
    
    private init() {}
    
    /// 제스처 표시 (자동 해제 타이머 포함)
    func showGesture(_ gesture: GestureType) {
        // 기존 타이머 취소
        gestureTimer?.invalidate()
        
        // 새 제스처 설정
        currentGesture = gesture
        
        // 햅틱 피드백
        playHapticFeedback(for: gesture)
        
        // none이 아닌 경우에만 자동 해제 타이머 설정
        if gesture != .none {
            gestureTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.currentGesture = .none
                }
            }
        }
    }
    
    /// 즉시 제스처 해제
    func hideGesture() {
        gestureTimer?.invalidate()
        currentGesture = .none
    }
    
    /// 제스처에 따른 햅틱 피드백 재생
    private func playHapticFeedback(for gesture: GestureType) {
        guard gesture != .none else { return }
        
        let impactGenerator: UIImpactFeedbackGenerator
        
        switch gesture {
        case .stop:
            impactGenerator = UIImpactFeedbackGenerator(style: .heavy) // 정지는 강한 진동
        case .boomUp, .boomDown:
            impactGenerator = UIImpactFeedbackGenerator(style: .medium) // 붐은 중간 진동
        case .none:
            return
        }
        
        impactGenerator.impactOccurred()
    }
}