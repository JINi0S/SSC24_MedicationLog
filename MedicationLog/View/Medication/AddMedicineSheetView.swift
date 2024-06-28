//
//  AddMedicineSheetView.swift
//  MedicationLog
//
//  Created by Lee Jinhee on 2/20/24.
//

import SwiftUI

struct AddMedicineSheetView: View {
    
    @State var medicine: Medicine = Medicine(name: "", capacity: "", capacityUnit: .mg, frequency: [Frequency(day: [], type: .Time(.now))])
    
    @Binding var addButtonTapped: Bool
    
    @State var time: [Date] = [Date.now]
    @State var showErrorAlert: Bool = false
    
    var createMedicineAble: Bool {
        return !medicine.name.isEmpty && !medicine.capacity.isEmpty && !medicine.frequency.isEmpty && medicine.frequency.filter({ $0.day.isEmpty }).count == 0
    }
    
    var createMedicineErrorMeessage: String {
        var str: String = "Please fill the "
        if medicine.name.isEmpty {
            str += "\"Name\""
        } else if medicine.capacity.isEmpty {
            str += "\"Capacity\""
        } else if medicine.frequency.isEmpty {
            str += "\"Frequency\""
        } else if medicine.frequency.filter({ $0.day.isEmpty }).count != 0 {
            str += "\"Day\""
        }
        str += " area"
        return str
    }
    
    var body: some View {
        Form {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    nameView
                    
                    capacityView
                    
                    frequencyView
                    
                    addFrequencyButtonView
                }
                .padding(20)
            }
        }
        .formStyle(.columns)
        .onChange(of: time) { time in
            // MARK: Time 저장
            for tIdx in 0..<time.count {
                if medicine.frequency[tIdx].type.title == "Time" {
                    medicine.frequency[tIdx].type  = .Time(time[tIdx])
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", role: .cancel) {
                    addButtonTapped = false
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if createMedicineAble {
                        dump(medicine)
                        MedicineService.shared.addMedicine(medicine: medicine)
                        addButtonTapped = false
                    } else {
                        showErrorAlert = true
                    }
                } label: {
                    Text("Done")
                        .foregroundStyle(createMedicineAble ? Color.ML_DarkBlue : Color.GrayAF)
                        .bold()
                }
            }
        })
        .alert("Failed to add", isPresented: $showErrorAlert, actions: {
            Button(role: .cancel) {
                showErrorAlert = true
            } label: {
                Text("OK")
            }
        }, message: {
            Text(createMedicineErrorMeessage)
        })
        .navigationTitle("Add medicine")
        .navigationBarTitleDisplayMode(.inline)
        .foregroundStyle(Color.ML_DarkBlue)
    }
    
    private var nameView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Name")
                .font(.headLine3)
                .foregroundStyle(.textBlack)
            
            TextField("Enter the name of the medicine", text: $medicine.name)
                .labelsHidden()
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.ML_Primary.opacity(0.1))
                )
        }
    }
    
    private var capacityView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Capacity")
                .font(.headLine3)
                .foregroundStyle(.textBlack)
            HStack {
                TextField("Enter the capacity of the medicine", text: $medicine.capacity).keyboardType(.decimalPad)
                    .labelsHidden()
                
                Spacer(minLength: 0)
                Picker("\(medicine.capacityUnit.rawValue)", selection: $medicine.capacityUnit) {
                    Text("mg").tag(CapacityUnit.mg)
                    Text("mcg").tag(CapacityUnit.mcg)
                    Text("g").tag(CapacityUnit.g)
                }
                .foregroundStyle(Color.ML_DarkBlue)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.primary100.opacity(0.1))
            )
        }
    }
    
    private var frequencyView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Frequency")
                .font(.headLine3)
                .foregroundStyle(.textBlack)
            
            ForEach(Array(medicine.frequency.enumerated()), id: \.element.id) { idx, frequency in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select day")
                        .font(.headLine4)
                        .foregroundStyle(.textBlack)
                    frequencyDayComponentView(frequency: frequency, idx: idx)
                        .padding(.bottom, 12)
                        
                    Text("Select time and count")
                        .font(.headLine4)
                        .foregroundStyle(.textBlack)
                    frequencyTimeComponentView(frequency: frequency, idx: idx)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.GrayF6.opacity(0.5))
                )
                .padding(.bottom, 12)
            }
        }
    }
    
    private func frequencyDayComponentView(frequency: Frequency, idx: Int) -> some View {
        HStack {
            ForEach(Day.allCases, id: \.rawValue) { day in
                Button {
                    if let dayIdx = medicine.frequency[idx].day.firstIndex(where: { $0.rawValue == day.rawValue }) {
                        medicine.frequency[idx].day.remove(at: dayIdx)
                    } else {
                        medicine.frequency[idx].day.append(day)
                    }
                } label: {
                    CircleLabelView(text: day.rawValue, isAble: frequency.day.contains(where: { $0.rawValue == day.rawValue }))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func frequencyTimeComponentView(frequency: Frequency, idx: Int) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Menu {
                Button(FrequencyType.CustomTime(.BeforeBedtime).title, action: {
                    if let idx = medicine.frequency.firstIndex(where: { $0.id == frequency.id }) {
                        medicine.frequency[idx].type = .CustomTime(.BeforeBedtime)
                    }
                })
                
                Button(FrequencyType.NotSpecified.title, action: {
                    if let idx = medicine.frequency.firstIndex(where: { $0.id == frequency.id }) {
                        medicine.frequency[idx].type = .NotSpecified
                    }
                })
                
                Button(FrequencyType.Time(nil).title, action: {
                    if let idx = medicine.frequency.firstIndex(where: { $0.id == frequency.id }) {
                        medicine.frequency[idx].type = .Time(nil)
                    }
                })
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.up.chevron.down")
                    Text("\(frequency.type.title)")
                    Spacer(minLength: 0)
                }
                .foregroundStyle(Color.ML_DarkBlue)
            }
            .frame(width: 160)
            
            Group {
                switch medicine.frequency[idx].type {
                case .CustomTime(_):
                    Menu {
                        ForEach(FrequencyCustomTime.allCases, id: \.rawValue) { customTime in
                            Button(customTime.rawValue, action: {
                                if let idx = medicine.frequency.firstIndex(where: { $0.id == frequency.id }) {
                                    medicine.frequency[idx].type = .CustomTime(customTime)
                                }
                            })
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Spacer(minLength: 0)
                            Text("\(medicine.frequency[idx].type.selection)")
                            Image(systemName: "chevron.up.chevron.down")
                        }
                        .foregroundStyle(Color.ML_DarkBlue)
                    }
                case .NotSpecified:
                    Rectangle().foregroundStyle(.clear)
                case .Time(_):
                    DatePicker("", selection: $time[idx], displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .changeTextColor(Color.ML_DarkBlue)
                }
            }
            .frame(width: 150, height: 60)
            
            Spacer(minLength: 0)
            Group {
                Button {
                    if medicine.frequency[idx].count > 1 {
                        medicine.frequency[idx].count -= 1
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.ML_Primary.opacity(0.4))
                        .frame(width: 34, height: 34)
                        .overlay {
                            Image(systemName: "minus")
                                .foregroundStyle(Color.ML_Primary)
                        }
                }
                Text("\(frequency.count)")
                    .frame(width: 60)
                Button {
                    medicine.frequency[idx].count += 1
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.ML_Primary.opacity(0.4))
                        .frame(width: 34, height: 34)
                        .overlay {
                            Image(systemName: "plus")
                                .foregroundStyle(Color.ML_Primary)
                        }
                }
            }
        }
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.ML_Primary.opacity(0.1))
        )
    }
        
    private var addFrequencyButtonView: some View {
        Button {
            time.append(Date.now)
            medicine.frequency.append(Frequency(day: [], type: .Time(.now)))
        } label: {
            Image(systemName: "plus")
                .font(.headLine2)
                .foregroundStyle(Color.GrayAF)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.GrayF6)
                )
        }
    }
}

#Preview {
    AddMedicineSheetView(addButtonTapped: .constant(true))
}
