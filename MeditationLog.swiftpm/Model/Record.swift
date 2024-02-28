//
//  TodayRecord.swift
//
//
//  Created by Lee Jinhee on 2/21/24.
//

import Foundation

struct TodayRecord {
    let date: Date
    var medicineList: [Medicine]?
    var sleepCycle: SleepCycle
    
    var doseList: [[Medicine]]

    var status: [[Status]]
    var sideEffects: [[SideEffect]]
    
    var videos: [URL]?
    var memo: String
    
    init() {
        self.date = Date.now
        self.medicineList = MedicineService.shared.filterMedicineByDay(day: Date().getDayOfWeek() ?? .Mon)
        self.sleepCycle = .init()
        self.doseList = Array(repeating: [], count: 24)
        self.status = Array(repeating: [], count: 24)
        self.sideEffects = Array(repeating: [], count: 24)
        self.videos = nil
        self.memo = ""
    }
    
    init(day: Date, medicineList: [Medicine]? = nil, sleepCycle: SleepCycle, doseList: [[Medicine]], status: [[Status]], sideEffects: [[SideEffect]], videos: [URL]? = nil, memo: String) {
        self.date = day
        self.medicineList = medicineList
        self.sleepCycle = sleepCycle
        self.doseList = doseList
        self.status = status
        self.sideEffects = sideEffects
        self.videos = videos
        self.memo = memo
    }
}

enum Status: String, CaseIterable {
    case Effective
    case Ineffective
    case Twisted
}

enum SideEffect: String, CaseIterable {
    case 두통
    case 우울증
    case 기립성저혈압
    case 어지러움
    case 졸음
    case 변비
    case 구역질
    case 구토
    
    var english: String {
        switch self {
        case .두통:
            "Headache"
        case .우울증:
            "Depression"
        case .기립성저혈압:
            "Orthostatic hypotension"
        case .어지러움:
            "Dizziness"
        case .졸음:
            "Sleepiness"
        case .변비:
            "Constipation"
        case .구역질:
            "Nauseousness"
        case .구토:
            "Vomiting"
        }
    }
}

struct SleepCycle: Equatable {
    init() {
        let calendar = Calendar.current
        
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        self.wakeupTime = calendar.date(from: components) ?? Date()
        
        components.hour = 21
        self.sleepTime = calendar.date(from: components) ?? Date()
    }
    
    var wakeupTime: Date
    var sleepTime: Date
    
    /// 수면 시작 시간과 깨어나는 시간의 차이를 계산하여 깨어있는 시간을 반환합니다.
    func calculateAwakeTime() -> TimeInterval {
        return sleepTime.timeIntervalSince(wakeupTime)
    }
    
    func isTimeBetweenWakeupAndSleep(hour: Int) -> Bool {
        let wakeupComponents = DateComponents(hour: wakeupTime.convertToLocalTime().getCurrentHour(), minute: 0)
        let sleepComponents = DateComponents(hour: sleepTime.convertToLocalTime().getCurrentHour(), minute: 0)
        
        guard let w = wakeupComponents.hour else { return false }
        guard let s = sleepComponents.hour else { return false }
        
        return w <= hour && hour <= s
    }
}
