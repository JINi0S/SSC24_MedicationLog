//
//  Medicine.swift
//
//
//  Created by Lee Jinhee on 2/20/24.
//

import Foundation

// TODO: 알약 이미지 선택 추가
struct Medicine: Identifiable {
    var id: UUID = UUID()
    
    var name: String
    var capacity: String
    var capacityUnit: CapacityUnit
    var frequency: [Frequency]
}

enum CapacityUnit: String {
    case mg
    case mcg
    case g
}

struct Frequency: Identifiable {
    var id = UUID()
    var day: [Day]
    var type: FrequencyType
    var count: Int
    
    init(id: UUID = UUID(), day: [Day], type: FrequencyType, count: Int = 1) {
        self.id = id
        self.day = day
        self.type = type
        self.count = count
    }
}

enum FrequencyType {
    case NotSpecified
    case Time(Date?)
    case CustomTime(FrequencyCustomTime)
    
    var title: String {
        switch self {
        case .NotSpecified:
            "As needed"
        case .Time:
            "Time"
        case .CustomTime(_):
            "MealTime"
        }
    }
    
    var selection: String {
        switch self {
        case .NotSpecified:
            "As needed"
        case .Time:
            "Time"
        case .CustomTime(let time):
            time.rawValue
        }
    }
    
    var value: String {
        switch self {
        case .NotSpecified:
            "As needed"
        case .Time(let time):
            dateToString(time: time ?? .now)
        case .CustomTime(let time):
            time.rawValue
        }
    }
    
    func dateToString(time: Date) -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}

enum FrequencyCustomTime: String, CaseIterable {
    case BeforeBedtime
    
    case BeforeBreakfast
    case AfterBreakfast
    
    case BeforeLunch
    case AfterLunch
    
    case BeforeDinner
    case AfterDinner
}
