//
//  Date.swift
//
//
//  Created by Lee Jinhee on 2/22/24.
//

import Foundation

extension Date {
    func toString(format: String = "MM/dd/yy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func getCurrentHour() -> Int {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        return hour % 24
    }
    
    func getDayOfWeek() -> Day? {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)

        switch weekday {
        case 1:
            return .Sun
        case 2:
            return .Mon
        case 3:
            return .Tue
        case 4:
            return .Wed
        case 5:
            return .Thu
        case 6:
            return .Fri
        case 7:
            return .Sat
        default:
            return nil
        }
    }
    
    func nextDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    func previousDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    func convertToLocalTime() -> Date {
        let calendar = Calendar.current
        // let timeZone = calendar.timeZone
        let localDate = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self))!
        return localDate
    }
    
    // MARK: - Week
    func getThisWeekRange() -> (Date, Date) {
        let calendar = Calendar.current
        
        // 해당 주의 시작 날짜(일요일)를 계산합니다.
        var startOfWeekComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: self)
        startOfWeekComponents.weekday = 1 // 일요일
        let startOfWeek = calendar.date(from: startOfWeekComponents)!
        
        // 해당 주의 종료 날짜(토요일)를 계산합니다.
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        
        return (startOfWeek, endOfWeek)
    }
    
    func previousWeekRange() -> (start: Date, end: Date) {
        let calendar = Calendar.current
        var startOfWeek = Date()
        var interval = TimeInterval()
        _ = calendar.dateInterval(of: .weekOfYear, start: &startOfWeek, interval: &interval, for: self)
        let endOfWeek = startOfWeek.addingTimeInterval(interval - 1)
        let startOfPreviousWeek = startOfWeek.addingTimeInterval(-interval)
        let endOfPreviousWeek = endOfWeek.addingTimeInterval(-interval)
        return (startOfPreviousWeek, endOfPreviousWeek)
    }
    
    func nextWeekRange() -> (start: Date, end: Date) {
        let calendar = Calendar.current
        var startOfWeek = Date()
        var interval = TimeInterval()
        _ = calendar.dateInterval(of: .weekOfYear, start: &startOfWeek, interval: &interval, for: self)
        let startOfNextWeek = startOfWeek.addingTimeInterval(interval)
        let endOfNextWeek = startOfNextWeek.addingTimeInterval(interval - 1)
        return (startOfNextWeek, endOfNextWeek)
    }
    
    
    // MARK: - Month
    func getThisMonthRange() -> (Date, Date) {
        let calendar = Calendar.current
        
        // 해당 월의 시작 날짜를 계산합니다.
        let startOfMonthComponents = calendar.dateComponents([.year, .month], from: self)
        let startOfMonth = calendar.date(from: startOfMonthComponents)!
        
        // 해당 월의 다음 달의 시작 날짜를 계산합니다.
        let startOfNextMonth = calendar.date(byAdding: DateComponents(month: 1), to: startOfMonth)!
        
        // 해당 월의 종료 날짜(다음 달의 시작 날짜의 하루 전)를 계산합니다.
        let endOfMonth = calendar.date(byAdding: DateComponents(day: -1), to: startOfNextMonth)!
        
        return (startOfMonth, endOfMonth)
    }
    
    func startOfMonth() -> Date {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    }
    
    func nextMonthRange() -> (Date, Date) {
        let calendar = Calendar.current
        
        // 다음 달의 시작 날짜를 계산합니다.
        let startOfNextMonth = calendar.date(byAdding: DateComponents(month: 1), to: self.startOfMonth())!
        
        // 다음 달의 종료 날짜(다다음 달의 시작 날짜의 하루 전)를 계산합니다.
        let startOfAfterNextMonth = calendar.date(byAdding: DateComponents(month: 1), to: startOfNextMonth)!
        let endOfNextMonth = calendar.date(byAdding: DateComponents(day: -1), to: startOfAfterNextMonth)!
        
        return (startOfNextMonth, endOfNextMonth)
    }
    
    func previousMonthRange() -> (Date, Date) {
        let calendar = Calendar.current
        
        // 이전 달의 시작 날짜를 계산합니다.
        let startOfPreviousMonth = calendar.date(byAdding: DateComponents(month: -1), to: self.startOfMonth())!
        
        // 이번 달의 시작 날짜를 계산합니다.
        let startOfMonth = self.startOfMonth()
        
        // 이전 달의 종료 날짜(이번 달의 시작 날짜의 하루 전)를 계산합니다.
        let endOfPreviousMonth = calendar.date(byAdding: DateComponents(day: -1), to: startOfMonth)!
        
        return (startOfPreviousMonth, endOfPreviousMonth)
    }
}
