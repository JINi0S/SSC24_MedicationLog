//
//  SummaryView.swift
//
//
//  Created by Lee Jinhee on 2/21/24.
//

import SwiftUI

enum SummaryType: String, CaseIterable {
    case Week
    case Month
}

struct SummaryView: View {
    @ObservedObject var vm: SummaryViewModel
    @State var showTip: Bool = false
    let tipText: String = "In Summary tab, you can check the average weekly and monthly logs\nbased on the information of the medication you are taking and the recorded information."
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
           
            HStack(spacing: 20) {

                Text("Summary")
                    .font(.title1B)
                
                Spacer()
             
                Button{
                    showTip.toggle()
                } label: {
                    Image(systemName: "questionmark.circle")
                        .font(.headLine2)
                        .foregroundStyle(Color.ML_DarkBlue)

                }
                .popover(isPresented: $showTip, arrowEdge: .bottom) {
                    Text(tipText)
                        .padding()
                        .foregroundStyle(.textBlack)
                }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 36) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Dosage information")
                            .font(.headLine1)
                        medicationRecordView
                    }
                    .padding(32)
                    .background(RoundedRectangle(cornerRadius: 32).foregroundStyle(.white))

                    VStack(alignment: .leading, spacing: 24) {
                        Text("Statistics")
                            .font(.headLine1)
                        
                        typeSelectView
                        
                        periodSelectView
                        
                        VStack(alignment: .leading, spacing: 32) {
                            overviewView
                            
                            medicationStatisticsView
                            
                            // efficacyStatisticsView
                        }
                    }
                    .padding(32)
                    .background(RoundedRectangle(cornerRadius: 32).foregroundStyle(.white))
                }
                .padding(.bottom, 60)
            }.scrollIndicators(.hidden)
        }
        .padding(.top, 12)
        .padding(.horizontal, 28)
        .shadow(color: .GrayAF.opacity(0.1), radius: 14, x: 0, y: 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.GrayAF.opacity(0.08))
        .foregroundStyle(.textBlack)
        .task {
            vm.task()
        }
    }
        
    private var typeSelectView: some View {
        HStack(spacing: 12) {
            ForEach(SummaryType.allCases, id: \.rawValue) { log in
                let selected = vm.selectedType == log
                Button {
                    vm.selectedType = log
                    if log == .Week {
                        vm.selectedDateList = (Date().getThisWeekRange())
                        vm.fetchSelectedDayRecordList()
                    }
                    if log == .Month {
                        vm.selectedDateList = (Date().getThisMonthRange())
                        vm.fetchSelectedDayRecordList()
                    }
                } label: {
                    Text(log.rawValue)
                        .font(selected ? .button2B : .button2)
                        .foregroundStyle(selected ? .textBlack : .textBlack.opacity(0.7))
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 36)
                .background {
                    RoundedRectangle(cornerRadius: 18)
                        .foregroundStyle(selected ? .white : .clear)
                }
            }
        }
        .padding(.all, 3)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(Color.GrayF6)
        }
    }
    
    private var periodSelectView: some View {
        HStack(spacing: 16) {
            Button {
                switch vm.selectedType {
                case .Week:
                    vm.selectedDateList = vm.selectedDateList.0.previousWeekRange()
                case .Month:
                    vm.selectedDateList = vm.selectedDateList.0.previousMonthRange()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headLine3)
            }
            
            switch vm.selectedType {
            case .Week:
                Text("\(vm.selectedDateList.0.toString(format: "MM/dd/yy")) ~ \(vm.selectedDateList.1.toString(format: "MM/dd/yy"))")
                    .font(.headLine2)
            case .Month:
                Text("\(vm.selectedDateList.0.toString(format: "MM/dd/yy")) ~ \(vm.selectedDateList.1.toString(format: "MM/dd/yy"))")
                    .font(.headLine2)
            }
            
            Button {
                switch vm.selectedType {
                case .Week:
                    vm.selectedDateList = vm.selectedDateList.0.nextWeekRange()
                case .Month:
                    vm.selectedDateList = vm.selectedDateList.0.nextMonthRange()
                }
               
            } label: {
                Image(systemName: "chevron.right")
                    .font(.headLine3)
            }
        }
        .foregroundStyle(.textBlack)
    }
    
    private var medicationRecordView: some View {
        Group {
            if let medicineList = vm.medicineList, !medicineList.isEmpty {
                LazyVStack(alignment: .center, spacing: 20) {
                    ForEach(medicineList, id: \.id) { medicine in
                        medicineComponent(medicine: medicine)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .padding(.top, 4)
            }
        }
    }
    
    private func medicineComponent(medicine: Medicine) -> some View {
        HStack(alignment: .top, spacing: 8) {
            
            Circle().frame(width: 36, height: 36)
                .foregroundStyle(Color.white.shadow(.inner(color: Color.black.opacity(0.3), radius: 4, x: -2, y: -2)))
                .offset(y: -6)
            
            Text(medicine.name)
                .font(.headLine3)
                .frame(width: 240)
            
            VStack(spacing: 20) {
                ForEach(medicine.frequency.indices) { idx in
                    let fq = medicine.frequency[idx]
                    HStack(spacing: 12) {
                        Text("\(fq.day.map({ $0.rawValue }).joined(separator: " "))")
                            .font(.body18)
                            .frame(width: 140)
                        Text("\(fq.type.value)")
                            .font(.body18)
                            .frame(width: 140)
                        Text("**\(fq.count)** Tablet")
                            .font(.body18)
                            .frame(width: 68)
                    }
                }
            }
        }
        .foregroundStyle(.textBlack)
    }
    
    private var overviewView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Average Overview")
                .font(.headLine3)
            HStack(spacing: 0) {
                if let recordList = vm.selectedDayRecordList {
                    overviewComponent(title: "Dosage frequency", value: vm.calculateAverageDosage(for: recordList), unit: "times") // 투약 횟수
                    // overviewComponent(title: "Duration of efficacy", value: "0", unit: "m") // 약효 유지 시간
                    Divider().padding(4)
                    overviewComponent(title: "Awake time", value: vm.calculateAwakeAverage(for: recordList), unit: "") // 깨어 있는 시간
                    overviewComponent(title: "With efficacy", value: vm.calculateEfficacyAverage(for: recordList), unit: "h") // 약효 있는 시간
                    overviewComponent(title: "Without efficacy", value: vm.calculateInefficacyAverage(for: recordList), unit: "h") // 약효 없는 시간
                } else {
                    overviewComponent(title: "Dosage frequency", value: "0", unit: "times") // 투약 횟수
                    // overviewComponent(title: "Duration of efficacy", value: "0", unit: "m") // 약효 유지 시간
                    Divider().padding(4)
                    overviewComponent(title: "Awake time", value: "0", unit: "h") // 깨어 있는 시간
                    overviewComponent(title: "With efficacy", value: "0", unit: "h") // 약효 있는 시간
                    overviewComponent(title: "Without efficacy", value: "0", unit: "h") // 약효 없는 시간
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.all, 18)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.ML_Primary.opacity(0.1))
            )
        }
    }
    
    private func overviewComponent(title: String, value: String, unit: String) -> some View {
        VStack(spacing: 8) {
            Text("\(title)")
                .font(.headLine5)
                .foregroundStyle(Color.ML_DarkBlue)
            HStack(alignment: .bottom) {
                Text(value)
                    .font(.title2B)
                    .foregroundStyle(.textBlack)
                Text("\(unit)")
                    .font(.footnote16)
                    .foregroundStyle(Color.GrayAF)
                    .offset(y: -2)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var medicationStatisticsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("MedicationStatistics")
                .font(.headLine3)

            VStack {
                ChartView(datas: vm.mdChartData)
            }
            .frame(maxWidth: .infinity)
            .padding(.all, 18)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.ML_Primary.opacity(0.1))
            )
        }
    }
    
    // TODO: 차트 구현
    private var efficacyStatisticsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("EfficacyStatistics")
                .font(.headLine3)
            VStack { }
            .frame(maxWidth: .infinity)
            .padding(.all, 18)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.ML_Primary.opacity(0.1))
            )
        }
    }
}

#Preview {
    SummaryView(vm: SummaryViewModel())
}
