//
//  MedicineService.swift
//
//
//  Created by Lee Jinhee on 2/21/24.
//

import Foundation

class MedicineService {
    
    static let shared: MedicineService = MedicineService()
    
    @Published var medicineList: [Medicine] = [
        Medicine(name: "Levodopa", capacity: "200", capacityUnit: .mg, frequency: [Frequency(day: [.Mon, .Wed, .Fri], type: .NotSpecified, count: 1)]),
        Medicine(name: "Pramipexole", capacity: "0.75", capacityUnit: .mg, frequency: [Frequency(day: [.Mon, .Tue, .Wed], type: .CustomTime(.BeforeBedtime), count: 1), Frequency(day: [.Sat, .Sun], type: .NotSpecified, count: 1)])
    ]
    
    func filterMedicineByDay(day: Day) -> [Medicine] {
        return medicineList.filter { $0.frequency.contains { $0.day.contains { $0.rawValue == day.rawValue } } }
    }
    
    func addMedicine(medicine: Medicine) {
        medicineList.append(medicine)
    }
}
