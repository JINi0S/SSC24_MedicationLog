//
//  LogViewModel.swift
//
//
//  Created by Lee Jinhee on 2/23/24.
//

import Foundation
import Combine

class LogViewModel: ObservableObject {
    
    @Published var selectedType: LogType = .Day
    @Published var selectedDate = Date()
    {
        didSet {
            fetchSelectedDayRecord()
        }
    }
    
    @Published var selectedDateList = (Date().getThisWeekRange())
    {
        didSet {
            fetchSelectedDayRecord()
            fetchSelectedDayRecordList()
        }
    }
    
    @Published var todayRecord: TodayRecord?
    @Published var selectedDayRecord: TodayRecord?
    @Published var selectedDayRecordList: [TodayRecord]? = [] // 주,월 할 떄
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        RecordService.shared.$todayRecord
            .sink { [weak self] record in
                self?.todayRecord = record
            }
            .store(in: &cancellables)
        
        fetchSelectedDayRecord()
        fetchSelectedDayRecordList()
    }
    
    func fetchSelectedDayRecord() {
        if Calendar.current.isDateInToday(selectedDate) {
            // 선택된 날짜가 오늘인 경우
            self.selectedDayRecord = self.todayRecord
        } else {
            // 선택된 날짜가 오늘이 아닌 경우
            self.selectedDayRecord = RecordService.shared.getRecord(for: selectedDate)
        }
    }
    
    func fetchSelectedDayRecordList() {
        self.selectedDayRecordList = RecordService.shared.getRecords(from: selectedDateList.0, to: selectedDateList.1)
    }
    
}
