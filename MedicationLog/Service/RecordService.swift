//
//  RecordService.swift
//
//
//  Created by Lee Jinhee on 2/21/24.
//

import Foundation
import Combine

class RecordService {
    
    static let shared: RecordService = RecordService()
    
    private var allRecordPublisher: AnyPublisher<[TodayRecord], Never> {
        $allRecord
            .eraseToAnyPublisher()
    }
    
    // todayRecord를 자동으로 업데이트하기 위한 Cancellable
    private var cancellable: AnyCancellable?
    
    //    @Published var allRecord: [TodayRecord] = [TodayRecord()]
    @Published var allRecord: [TodayRecord] =
    [
        TodayRecord(
            day: .now.previousDay().previousDay(),
            sleepCycle: .init(),
            doseList: [[], [],[],[],[],[],
                       [],[],[MedicineService.shared.medicineList.first!],[],[],MedicineService.shared.medicineList,[],
                       [],[],[MedicineService.shared.medicineList.first!],[],
                       [],[],[],[],[],[], []
                      ],
            status: [[],[],[],[],[],[],[],[],[],[],[.Effective],[.Effective],
                     [.Effective],[.Effective],[.Ineffective],[.Ineffective, .Twisted],[.Ineffective, .Twisted],[.Ineffective],
                     [.Effective],[.Effective],[.Effective],[.Effective],[.Ineffective],[]],
            sideEffects: [[],[],[],[],[], [],
                          [],[],[],[],[.구역질, .두통],[],
                          [.기립성저혈압],[],[],[],[.구역질],[.구역질,],
                          [],[],[],[],[],[]
                         ], memo: "Tired today"
        ), TodayRecord(
            day: .now.previousDay(),
            sleepCycle: .init(),
            doseList: [[], [],[],[],[],[],
                       [],[],[],[],[],[],
                       MedicineService.shared.medicineList,[],[],[],[MedicineService.shared.medicineList.first!],[],
                       [],[],[],[],[],[]
                      ],
            status: [[],[],[],[],[],[],[],[],[],[],[.Effective],[.Effective],
                     [.Effective],[.Effective],[.Ineffective],[.Twisted],[.Twisted],[.Ineffective],
                     [.Effective],[.Effective],[.Ineffective],[],[],[]],
            sideEffects: [[],[],[],[],[],[],
                          [],[],[],[],[],[],
                          [],[],[.두통], [],[],[],
                          [],[],[],[],[],[]
                         ], memo: ""
        )
    ]
    
    
    //allRecord에 하나라도 넣어주면 작동하긴함 > 확인은 해봐야댐 다른날짜 있을 떄
    @Published var todayRecord: TodayRecord = TodayRecord()
    {
        didSet {
            // todayRecord가 변경될 때마다 allRecord에 반영
            if allRecord.isEmpty {
                allRecord = [todayRecord]
            } else {
                if let index = allRecord.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: todayRecord.date) }) {
                    allRecord[index] = todayRecord
                } else {
                    allRecord.append(todayRecord)
                }
            }
        }
    }
    @Published var periodRecord: [TodayRecord] = []
    
    init() {
        // 초기화 이후에 현재 날짜를 기반으로 todayRecord를 설정
        updateTodayRecord()
    }
    
    
    // 현재 날짜를 기반으로 todayRecord를 설정하는 함수
    func updateTodayRecord() {
        if allRecord.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: Date()) }) {
            if let todayRecord = allRecord.first(where: { Calendar.current.isDate($0.date, inSameDayAs: Date()) }) {
                self.todayRecord = todayRecord
            }
        } else {
            todayRecord = TodayRecord()
        }
    }
    
    func appendVideoUrlToTodayRecord(url: URL) {
        dump(url)
        if let _ = todayRecord.videos {
            todayRecord.videos?.append(url)
        } else {
            todayRecord.videos = [url]
        }
    }
    
    /// 주어진 날짜와 동일한 날짜를 가진 TodayRecord를 찾아서 반환
    func getRecord(for date: Date) -> TodayRecord? {
        return allRecord.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
    }
    
    /// 두 날짜 사이의 데이터를 가져오는 메서드
    func getRecords(from startDate: Date, to endDate: Date) -> [TodayRecord] {
        let dateRange = startDate...endDate
        return allRecord.filter { dateRange.contains($0.date) }
    }
    
    func getRecordsForWeek(for date: Date) {
        let (startOfWeek, endOfWeek) = Date().getThisWeekRange()
        self.periodRecord = self.getRecords(from: startOfWeek, to: endOfWeek)
    }
    
  
    func sideEffectsDTO(from records: [TodayRecord]) -> [SideEffectDTO] {
        var sideEffectDTOs: [SideEffectDTO] = []
        
        for record in records {
            let dto = SideEffectDTO(date: record.date, sideEffects: record.sideEffects)
            sideEffectDTOs.append(dto)
        }
        
        return sideEffectDTOs
    }
    
    func videoUrlDTO(from records: [TodayRecord]) -> [VideoUrlDTO] {
        var urlDTOs: [VideoUrlDTO] = []
        
        for record in records {
            guard let videos = record.videos else { continue }
            let dto = VideoUrlDTO(date: record.date, urls: videos)//(date: record.date, sideEffects: record.sideEffects)
            urlDTOs.append(dto)
        }
        
        return urlDTOs
    }
    
    func memoDTO(from records: [TodayRecord]) -> [MemoDTO] {
        var memosDTOs: [MemoDTO] = []
        
        for record in records {
            if !record.memo.isEmpty {
                let dto = MemoDTO(date: record.date, memo: record.memo)
                memosDTOs.append(dto)
            }
        }
        
        return memosDTOs
    }
}
