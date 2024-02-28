//
//  File.swift
//  
//
//  Created by Lee Jinhee on 2/24/24.
//

import Foundation
import Combine

class SummaryViewModel: ObservableObject {
    
    @Published var selectedType: SummaryType = .Week
    
    @Published var selectedDateList = (Date().getThisWeekRange())
    {
        didSet {
            fetchSelectedDayRecordList()
            calMedicationChart()
        }
    }
    
    @Published var medicineList: [Medicine]?
    
    @Published var todayRecord: TodayRecord?
    @Published var selectedDayRecord: TodayRecord?
    @Published var selectedDayRecordList: [TodayRecord]? = [] // 주,월 할 떄
    
    @Published var mdChartData: [ChartData] = [
        ChartData(day: .Sun, count: 0),
        ChartData(day: .Mon, count: 0),
        ChartData(day: .Tue, count: 0),
        ChartData(day: .Wed, count: 0),
        ChartData(day: .Thu, count: 0),
        ChartData(day: .Fri, count: 0),
        ChartData(day: .Sat, count: 0)
    ]
        
    private let chartDefaultDatas: [ChartData] = [
        ChartData(day: .Sun, count: 0),
        ChartData(day: .Mon, count: 0),
        ChartData(day: .Tue, count: 0),
        ChartData(day: .Wed, count: 0),
        ChartData(day: .Thu, count: 0),
        ChartData(day: .Fri, count: 0),
        ChartData(day: .Sat, count: 0)
    ]
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        RecordService.shared.$todayRecord
            .sink { [weak self] record in
                self?.todayRecord = record
            }
            .store(in: &cancellables)
    }
    
    func task() {
        fetchMedicinaInfo()
        fetchSelectedDayRecordList()
        calMedicationChart()
    }
    
    func fetchMedicinaInfo() {
        self.medicineList = MedicineService.shared.medicineList
    }
    
    func fetchSelectedDayRecordList() {
        self.selectedDayRecordList = RecordService.shared.getRecords(from: selectedDateList.0, to: selectedDateList.1)
        
    }
    
    // MARK: 평균 복용 횟수
    func calculateAverageDosage(for records: [TodayRecord]) -> String {
        let (startDate, endDate) = (selectedDateList.0, selectedDateList.1)
        
        // 선택한 start와 end Date 사이의 TodayRecord 배열 필터링
        let filteredRecords = records.filter { record in
            return startDate <= record.date && record.date <= endDate
        }
        
        // 필터링된 TodayRecord 배열에서 doseList의 총합 계산
        let totalDoseCount = filteredRecords.map { $0.doseList }.reduce(0) { $0 + $1.filter({ !$0.isEmpty }).count }
        
        // 필터링된 TodayRecord 배열의 개수
        let recordCount = filteredRecords.count
        print(totalDoseCount, recordCount)
        // 평균 계산
        let average: Double
        if recordCount != 0 {
            average = Double(totalDoseCount) / Double(recordCount)
        } else {
            average = 0
        }
        
        // 평균 값을 소숫점 둘째 자리까지 반올림하여 String으로 변환
        let formattedAverage = String(format: "%.1f", average)
        
        return formattedAverage
    }
    
    // MARK: 평균 깨어있는 시간
    func calculateAwakeAverage(for records: [TodayRecord]) -> String {
        let (startDate, endDate) = (selectedDateList.0, selectedDateList.1)
        
        // 주어진 기간 동안의 모든 수면 주기를 가져옵니다.
        let filteredRecords = records.filter { record in
            return startDate <= record.date && record.date <= endDate
        }
        
        // 주어진 기간 동안의 모든 수면 주기에 대해 깨어있는 시간을 계산합니다.
        let awakeTimes = filteredRecords.map { cycle in
            return cycle.sleepCycle.calculateAwakeTime()
        }
        
        // 깨어있는 시간의 총합을 계산합니다.
        let totalAwakeTime = awakeTimes.reduce(0, +)
        
        // 평균 깨어있는 시간을 계산합니다.
        let averageAwakeTime = Double(totalAwakeTime) / Double(filteredRecords.count)
        print(averageAwakeTime)
        
        let average: Double
        if filteredRecords.count != 0 {
            average = Double(totalAwakeTime) / Double(filteredRecords.count)
        } else {
            average = 0
        }
        
        // 시간 형식으로 변환하여 반환합니다.
        let hours = Int(average / 3600) // 시간 계산
        let minutes = Int((average.truncatingRemainder(dividingBy: 3600)) / 60) // 분 계산
        
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    // MARK: 평균 약효 있는 시간
    // TODO: 그냥 뷰모델에서 records필터한번 하는데, 뷰에서 한 번 더하는 느낌?
    func calculateEfficacyAverage(for records: [TodayRecord]) -> String {
        let (startDate, endDate) = (selectedDateList.0, selectedDateList.1)
        
        // 주어진 기간 동안의 모든 기록 가져옵니다.
        let filteredRecords = records.filter { record in
            return startDate <= record.date && record.date <= endDate
        }
        
        // 주어진 기간 동안의 모든 수면 주기에 대해 약효있는 시간을 계산합니다.
        let efficacyTimes = filteredRecords.map { record in
            return record.status.filter { $0.contains(.Effective) }.count
        }
        
        // 약효있는 시간의 총합을 계산합니다.
        let totalEfficacyTime = efficacyTimes.reduce(0, +)
        
        // 평균 시간을 계산합니다.
        let average: Double
        if efficacyTimes.count != 0 {
            average = Double(totalEfficacyTime) / Double(efficacyTimes.count)
        } else {
            average = 0
        }
        
        return String(format: "%.1f", average)
    }
    
    // MARK: 평균 약효 없 시간
    // TODO: 그냥 뷰모델에서 records필터한번 하는데, 뷰에서 한 번 더하는 느낌?
    func calculateInefficacyAverage(for records: [TodayRecord]) -> String {
        let (startDate, endDate) = (selectedDateList.0, selectedDateList.1)
        
        // 주어진 기간 동안의 모든 기록 가져옵니다.
        let filteredRecords = records.filter { record in
            return startDate <= record.date && record.date <= endDate
        }
        
        // 주어진 기간 동안의 모든 수면 주기에 대해 약효없는 시간을 계산합니다.
        let inefficacyTimes = filteredRecords.map { record in
            return record.status.filter { $0.contains(.Ineffective) }.count
        }
        
        // 약효없는 시간의 총합을 계산합니다.
        let totalInefficacyTime = inefficacyTimes.reduce(0, +)
        
        // 평균 시간을 계산합니다.
        let average: Double
        if inefficacyTimes.count != 0 {
            average = Double(totalInefficacyTime) / Double(inefficacyTimes.count)
        } else {
            average = 0
        }
        return String(format: "%.1f", average)
    }
    
    // MARK: - Chart 관련
    func calMedicationChart() {
        self.mdChartData = chartDefaultDatas

        guard let recordList = self.selectedDayRecordList, !recordList.isEmpty else { return }
        
        for record in recordList where !record.doseList.isEmpty {
            let day = record.date.getDayOfWeek() ?? .Wed
            let sum = record.doseList.filter { !$0.isEmpty }.map { $0.count }.reduce(0, +)
            
            if let idx = self.mdChartData.firstIndex(where: { $0.day == day }) {
                mdChartData[idx].count += sum
            }
        }
    }
}
