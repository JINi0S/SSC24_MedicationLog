# Meditation Log

![image](https://github.com/JINi0S/SSC24_MedicationLog/assets/100195563/23f18caa-b599-4e91-bf6c-ecf5bdc1f6df)

**💊 파킨슨 환자를 위한 투약일지** 

파킨슨 환자를 위한 투약일지는 떨림 증상과 부작용 관리, 약 효능 추적에 중점을 두었습니다. 파킨슨 환자의 투약 목적은 완치가 아닌 증상 완화를 통한 보다 나은 삶의 영위이기 때문에, 효과적인 치료 계획을 세우는 것이 중요합니다. 따라서 이 앱은 단순히 약의 복용을 추적하는 것이 아닌 약의 효능이 유효한 시간을 추적하고, 몸이 꼬이거나 흔들리는 증상이 얼마나 지속되는지 추적합니다. 추후에는 보다 정확한 통계를 통해 치료 계획을 세우는데 도움을 줄 수 있습니다. 

24년도 Swift Student Challenge 제출 프로젝트로 심사를 기다리는 중입니다 ••• 👀
   
<br>

### ⬇️ 기획/개발 일지 확인하기

[https://jinios.tistory.com/category/🏆 Swift Student Challenge](https://jinios.tistory.com/category/%F0%9F%8F%86%20Swift%20Student%20Challenge)

<br>

### 💻 개발 기간

2월 16일 ~ 19일 (4일) 기획 및 디자인

2월 20일 ~ 26일 (7일) 개발

<br>


## **1. Develop Enviroment ⚖️**
`iOS 16.0` `Xcode 15.0` `Playground App`

<br>


## 2. 기능 요약 ✏️

- `Today` 탭에서는
    - 시간별로 약 섭취유무를 기록하고, 부작용과 떨림 상태를 기록할 수 있습니다.
    - 동영상과 메모로 현재 상태를 기록할 수 있습니다.
- `Summary` 탭에서는
    - 기록한 일지의 요약과 통계를 차트로 확인할 수 있습니다.
- `Log` 탭에서는
    - 과거 투약 기록과 부작용 기록을 볼 수 있으며 이미지로 저장할 수 있습니다.
- `Medication` 탭에서는
    - 투약중인 약을 추가할 수 있습니다.

<br>


## **3. 화면 구성**

| Today | Log | Summary |
|--------|--------|--------|
| <img src = "https://github.com/JINi0S/SSC24_MedicationLog/assets/100195563/b15887c4-2f72-4fdf-b21a-eb174e56d6cc" width = "300">  |  <img src = "https://github.com/JINi0S/SSC24_MedicationLog/assets/100195563/57da71c5-5f67-4021-81ec-7938295d75ab" width = "300">  | <img src = "https://github.com/JINi0S/SSC24_MedicationLog/assets/100195563/74873231-eb6e-4bcd-98e6-47b3851d9dc0" width = "300">  |

<br>

## 4. 사용 기능

- Enum을 활용하여 요일, 부작용, 상태, 투약 빈도 타입 등 객체의 타입을 정의했습니다.
- SwiftChart를 활용하여 투약 통계를 확인할 수 있도록 했습니다.
- @StateObject, @ObservedObject, Combine을 활용해서 생성된 객체를 관찰하여 해당 객체가 변경될 때마다 해당 뷰를 업데이트하는 방식으로 투약 기록을 관리했습니다.
- Date를 Extension하여 현재 월, 주, 요일,시간으로 화면 초기화하도록 하는 다양한 메서드를 추가했으며, 이전과 다음으로 변환하는 메서드를 구현했습니다.
- 가로모드, 세로모드, iPadOS 11, 12.9인치에서 유연하게 대응되도록 개발했으며, 탭간 이동이 쉽도록 하기 위해 내비게이션이 아닌 탭뷰로 개발하였습니다

<br>

## 5. 어려웠던 점


<br>

## 6. 이후 개선 방향

#릴리즈

- [ ]  App 프로젝트로 변환 후 배포 ‼️

#기능

- [ ]  Apple Login - iCloud 알아보기
- [ ]  Core Data로 정보 저장
- [ ]  약정보의 C**RUD**
- [ ]  약효 지속 시간에 대한 통계

#기획

- [ ]  온보딩 내용 → 사용방법에 대한 설명으로 수정

#디자인

- [ ]  iOS 고려하여 UI 고민 ‼️
- [ ]  UX 고민 ! - 색상 대비 및 버튼 인지
    

<br>

## 7.  **Folder Structure**
```makefile
├── Assets.xcassets
│   ├── AppIcon.appiconset
│   ├── Colors
│   └── Images
├── Component
│   ├── BlueButtonView.swift
│   ├── CircleLabelView.swift
│   └── WhiteTextView.swift
├── Enum
│   ├── Day.swift
│   └── LocalizedStringKey.swift
├── Extension
│   ├── Color++.swift
│   ├── Date++.swift
│   ├── Font++.swift
│   └── View++.swift
├── Model
│   ├── DTO.swift
│   ├── Medicine.swift
│   └── Record.swift
├── MyApp.swift
├── Package.swift
├── Service
│   ├── MedicineService.swift
│   └── RecordService.swift
└── View
├── 1.StartView.swift
├── 2.OnboardingView.swift
├── 3.MainView.swift
├── 4-1.TodayView.swift
├── 4-1.TodayViewModel.swift
├── ... 
├── ChartView.swift
├── TimeControllView.swift
└── Video.swift
```
