//
//  NearbyInteractionManager.swift
//  LetHimCook
//
//  Created by 김민석 on 8/24/25.
//

import Foundation
import NearbyInteraction
import os
import simd

/// MPC를 통해 discoveryToken(Data)을 교환하고 NISession을 구동하는 매니저
final class NearbyInteractionManager: NSObject, ObservableObject {
    enum Outgoing {
        case discoveryToken(Data)
    }

    private let log = Logger(subsystem: "LetHimCook", category: "NBI")
    private var session: NISession?
    private var hasSentMyToken = false

    /// MPC로 바이트를 보내는 함수 주입 (멀티피어 세션에서 제공)
    private let sendData: (Data) -> Void

    // 최신 측정값 (DriverMainView가 구독)
    @Published var distance: Double? = nil              // meters
    @Published var azimuth: Double? = nil               // radians (−π…π, 0은 정면)
    @Published var elevation: Double? = nil             // radians
    @Published var valid: Bool = false                  // 세션 유효 상태

    private var lastAzimuth: Double? = nil
    private var lastElevation: Double? = nil

    init(sendData: @escaping (Data) -> Void) {
        self.sendData = sendData
        super.init()
        startSessionIfPossible()
    }

    // MARK: Session lifecycle

    private func startSessionIfPossible() {
        guard NISession.isSupported else {
            log.error("❌ NearbyInteraction not supported on this device.")
            valid = false
            return
        }
        let s = NISession()
        s.delegate = self
        session = s
        hasSentMyToken = false
        valid = true
        log.info("✅ NISession created.")
        // 내 토큰을 상대에게 보내야 시작됨 → MPC 경로로 보냄
        sendMyDiscoveryTokenIfNeeded()
    }

    private func sendMyDiscoveryTokenIfNeeded() {
        guard let token = session?.discoveryToken, !hasSentMyToken else { return }
        do {
            let tokenData = try NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true)
            let packet = NearbyInteractionManager.wrap(type: .nbiToken, payload: tokenData)
            sendData(packet)
            hasSentMyToken = true
            log.info("📤 Sent my discovery token (\(tokenData.count) bytes)")
        } catch {
            log.error("❌ Token archive failed: \(error.localizedDescription)")
        }
    }

    /// 상대 토큰 수신시 호출 (MPC didReceive에서 연결)
    func receivePeerDiscoveryToken(_ data: Data) {
        guard let s = session else { return }
        do {
            guard let token = try NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) else {
                log.error("❌ Failed to decode peer token")
                return
            }
            let config = NINearbyPeerConfiguration(peerToken: token)
            s.run(config)
            log.info("▶️ NISession run with peer token.")
        } catch {
            log.error("❌ Peer token unarchive failed: \(error.localizedDescription)")
        }
    }

    private func restart() {
        log.info("🔄 Restart NISession")
        session?.invalidate()
        session = nil
        distance = nil
        azimuth = nil
        elevation = nil
        hasSentMyToken = false
        startSessionIfPossible()
    }

    // MARK: - 메시지 패킹/언패킹 (MPC 공용)

    enum MessageType: UInt8 {
        case nbiToken = 0x01
        // 필요시 타입 추가
    }

    static func wrap(type: MessageType, payload: Data) -> Data {
        var out = Data([type.rawValue])
        out.append(payload)
        return out
    }

    static func unwrap(_ data: Data) -> (MessageType, Data)? {
        guard let t = data.first, let type = MessageType(rawValue: t) else { return nil }
        return (type, data.dropFirst())
    }
}

extension NearbyInteractionManager: NISessionDelegate {
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        guard let obj = nearbyObjects.first else {
            Logger().info("ℹ️ didUpdate with empty objects")
            return
        }

        let distD: Double? = obj.distance.map { Double($0) }
        var azD: Double? = nil
        var elD: Double? = nil
        if let dir = obj.direction {
            let az = atan2(Double(dir.x), Double(-dir.z))
            let el = asin(Double(dir.y))
            azD = az
            elD = el
        }

//        Logger().info("📈 didUpdate distance=\(String(describing: distD)), dir=\(obj.direction.map { "\($0.x),\($0.y),\($0.z)" } ?? "nil")")

        DispatchQueue.main.async {
            self.distance  = distD
            self.azimuth   = azD
            self.elevation = elD
        }
    }

    func session(_ session: NISession, didInvalidateWith error: Error) {
        Logger().error("❌ NISession invalidated: \(error.localizedDescription)")
        DispatchQueue.main.async { self.valid = false }
        // 약간 쉬고 재시작(충돌 방지)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.restart()
        }
    }

    func sessionWasSuspended(_ session: NISession) {
        Logger().info("⏸️ NISession suspended")
    }

    func sessionSuspensionEnded(_ session: NISession) {
        Logger().info("▶️ NISession suspension ended, re-run")
        // peer token이 이미 설정되어 있으면 iOS가 알아서 갱신.
    }
}
