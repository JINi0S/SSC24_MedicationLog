//
//  TodayViewModel.swift
//  MedicationLog
//
//  Created by Lee Jinhee on 2/20/24.
//

import Combine
import Foundation

class TodayViewModel: ObservableObject {
    @Published var todayRecord: TodayRecord
    @Published var selectedTime: Int = 0
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.todayRecord = TodayRecord()
        
        getData()
    }
        
    func fetchCurrenTime() {
        selectedTime = Date().getCurrentHour()
    }
    
    private func getData() {
        RecordService.shared.$todayRecord
            .sink { [weak self] record in
                self?.todayRecord = record
            }
            .store(in: &cancellables)
    }
    
    func filterMedicine() {
        self.todayRecord.medicineList = MedicineService.shared.filterMedicineByDay(day: Date().getDayOfWeek() ?? .Mon)
    }
    
    func ateMedicine(medicine: Medicine) {
        if let index = RecordService.shared.todayRecord.doseList[selectedTime].firstIndex(where: { $0.id == medicine.id }) {
            RecordService.shared.todayRecord.doseList[selectedTime].remove(at: index)
        } else {
            RecordService.shared.todayRecord.doseList[selectedTime].append(medicine)
        }
        filterMedicine()
    }
    
    func containDoseList(_ medicine: Medicine) -> Bool {
        self.todayRecord.doseList[selectedTime].contains(where: { $0.id == medicine.id })
    }
    
    func containStatus(_ status: Status) -> Bool {
        self.todayRecord.status[selectedTime].contains(where: { $0.rawValue == status.rawValue })
    }
    
    func containSideEffect(_ effect: SideEffect) -> Bool {
        self.todayRecord.sideEffects[selectedTime].contains(where: { $0.rawValue == effect.rawValue })
    }
    
    // TODO: ref RecordService에 넣자
    func toggleSideEffect(_ effect: SideEffect) {
        if let index = RecordService.shared.todayRecord.sideEffects[selectedTime].firstIndex(where: { $0 == effect }) {
            RecordService.shared.todayRecord.sideEffects[selectedTime].remove(at: index)
        } else {
            RecordService.shared.todayRecord.sideEffects[selectedTime].append(effect)
        }
    }
    
    func toggleStatus(_ status: Status) {
        if let index = RecordService.shared.todayRecord.status[selectedTime].firstIndex(where: { $0 == status }) {
            RecordService.shared.todayRecord.status[selectedTime].remove(at: index)
        } else {
            RecordService.shared.todayRecord.status[selectedTime].append(status)
        }
    }
    
    func updateSleepCycle(_ cycle: SleepCycle) {
        RecordService.shared.todayRecord.sleepCycle = cycle
    }
    
    func leaveMemo(_ txt: String) {
        RecordService.shared.todayRecord.memo = txt
    }
}
