# 🏆 Junction Asia 2025 Track Winner

> **!! Track Winner of `Sankun` !!**  

> TEAM NAME : `Let Him Cook`

> PRIZE : `₩2,000,000`

<img width="350" alt="image" src="https://github.com/user-attachments/assets/a6c36efe-3cf4-43f4-aa49-7c4aec984b09" />
<img width="263" alt="image" src="https://github.com/user-attachments/assets/ce94f22c-e964-48db-bdf9-115b51f08efd" />

---

## 👥 Team Members

| <img src="https://github.com/giljihun.png" width="150"> | <img src="https://github.com/alstjr7437.png" width="150"> | <img src="https://github.com/junhajk.png" width="150"> | <img src="https://github.com/user-attachments/assets/2e9cfff6-b24d-44f9-8fc8-847269aef8f0" width="150"> |
| :---: | :---: | :---: | :---: |
| **길지훈** | **김민석** | **장준하** | **윤하정** |
| **iOS Developer** | **iOS Developer** | **PM / Data** | **UI/UX Design** |
| [@giljihun](https://github.com/giljihun) | [@alstjr7437](https://github.com/alstjr7437) | [@junhajk](https://github.com/junhajk) | [@y0_0n_.hx](https://www.behance.net/yhj17bb5265) |

## Signal Man
<img width="200" alt="1024" src="https://github.com/user-attachments/assets/035f4d64-aca5-4780-b695-a2347e1852eb" />

> "Signalman" - App icon

#### 실시간 수신호 인식
Apple Watch의 `Core Motion` 기술을 활용하여 신호수의 제스처(**붐 업, 붐 다운, 정지 등**)를 실시간으로 인식합니다.

#### 직관적인 신호 전달
인식된 신호는 `Multipeer Connectivity` 를 통해 즉시 운전자의 iPad/iPhone으로 전송되어, 명확한 시각적/촉각적 알림을 제공합니다.

#### 초정밀 거리 및 방향 감지
`Nearby Interaction 프레임워크(UWB)` 를 활용하여 신호수와 중장비(운전자) 간의 정밀한 거리와 방향을 측정하고, 위험 거리에 진입 시 강력한 경고를 보냅니다.

#### 모든 상호작용 로깅
신호수와 운전자 간의 모든 수신호, 응답, 거리 정보 등은 타임스탬프와 함께 기록되어, 사고 분석 및 안전 교육을 위한 귀중한 데이터로 활용됩니다.

## Background & Problem Definition

산군(Sankun) 트랙의 핵심 과제인 **공공 데이터를 활용한 건설 현장 안전 시스템**을 분석하며,   
우리는 산업 현장의 사고 데이터 속에서 유독 눈에 띄는 직업군인 **신호수**에 주목했습니다.

- **Pain Point:** 신호수는 중장비의 눈과 귀가 되어 사고를 방지하는 필수 인력이지만, 정작 본인들은 장비 사각지대에서 가장 빈번하게 사고 당사자가 됩니다.
- **The Gap:** 소음이 심한 현장에서 무전기나 수신호만으로는 운전자와의 완벽한 소통이 어렵고, 찰나의 오해가 대형 사고로 이어지는 구조적 한계가 있었습니다.

> 그렇게 우리는 신호수를 보호하고, 그들의 사인을 운전자에게 가장 직관적이고 확실하게 전달하기 위해 **Signalman**을 기획했습니다.

또한, 데이터 활용의 가치를 넘어 데이터 생성에 가치에 주목했습니다. 
- **Communication Logging:** 신호수와 운전자 간의 모든 수신호와 응답 시간을 기록하여 디지털화합니다.
- **Future Public Data:** 이렇게 생산된 데이터는 추후 산업 현장의 안전 매뉴얼 개선 및 AI 기반 안전 관제 시스템을 위한 귀중한 공공 데이터 자산이 될 수 있다고 판단했습니다.

## 기술 스택
   * **Platform**: iOS, watchOS
   * **Language**: Swift
   * **UI**: SwiftUI
   * **Core Technologies**:
       * MultipeerConnectivity: P2P 네트워크를 통한 iOS 기기 간 데이터 통신
       * WatchConnectivity: iPhone 앱과 Watch 앱 간의 실시간 통신
       * Core Motion: Apple Watch의 가속도계, 자이로스코프 센서를 이용한 동작 인식
       * Nearby Interaction: UWB(초광대역) 기술을 활용한 기기 간 거리 및 방향 정밀 측정
   * **Architecture**: MVVM

## 시연 영상

https://github.com/user-attachments/assets/acdd0ed7-ff6c-4281-9e8d-d29d584960b9

> 1. 신호수와 운전자 거리 감지 STOP
> 2. 정지 수신호
> 3. 붐 업
> 4. 붐 다운


## 동작 흐름
1. 연결: 신호수(Watch)와 운전자(iPad/iPhone)가 각자의 앱을 실행하여 P2P로 연결합니다.
2. 신호: 신호수가 특정 제스처를 취하면 Apple Watch가 이를 감지합니다.
3. 전송: 감지된 신호는 즉시 운전자의 기기로 전송됩니다.
4. 확인: 운전자는 화면에 뜬 명확한 시그널을 보고 작업을 수행합니다.
5. 기록: 모든 신호, 반응, 두 사용자 간의 거리 등 모든 과정이 자동으로 기록됩니다.

---


