//
//  TodayView.swift
//  MeditationLog
//
//  Created by Lee Jinhee on 2/19/24.
//

import SwiftUI
import PhotosUI
import _AVKit_SwiftUI

struct TodayView: View {
    
    @ObservedObject var vm: TodayViewModel
    @State var showTip: Bool = false
    private let tipText: String = "In the Today tab, you can record your status, side effects,\nand medication history by time. You can also record your status with videos and memos.\nThe recorded information can be reviewed in the Log tab, \nand summarized information can be checked in the Summary tab."

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                Text("Today")
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
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Record")
                            .font(.headLine1B)
                            .foregroundStyle(.textBlack)
                        selectTimeView
                        
                        scheduleView
                        
                        statusView
                        
                        sideEffectView
                    }
                    .padding(32)
                    .background(RoundedRectangle(cornerRadius: 32).foregroundStyle(.white))
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Sleep Cycle")
                            .font(.headLine1B)
                            .foregroundStyle(.textBlack)
                        
                        sleepCycleView
                    }
                    .padding(32)
                    .background(RoundedRectangle(cornerRadius: 32).foregroundStyle(.white))
                    
                    VStack(alignment: .leading, spacing: 20) {
                        memoWithPhotoVideo
                    }
                    .padding(32)
                    .background(RoundedRectangle(cornerRadius: 32).foregroundStyle(.white))
                }
                .padding(.bottom, 60)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.top, 12)
        .padding(.horizontal, 28)
        .shadow(color: .GrayAF.opacity(0.1), radius: 14, x: 0, y: 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.GrayAF.opacity(0.08))
        
        .task {
            vm.filterMedicine()
            vm.fetchCurrenTime()
        }
    }
    
    private var scheduleView: some View {
        Group {
            if let todayMedicineList = vm.todayRecord.medicineList, !todayMedicineList.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Today's medication")
                        .font(.headLine2)
                        .foregroundStyle(.textBlack)
                    ScrollView(.horizontal) {
                        LazyHStack(alignment: .center, spacing: 20) {
                            ForEach(todayMedicineList, id: \.id) { medicine in
                                scheduleMedicineView(medicine: medicine)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func scheduleMedicineView(medicine: Medicine) -> some View {
        Button {
            vm.ateMedicine(medicine: medicine)
        } label: {
            HStack(alignment: .center, spacing: 12) {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(Color.white.shadow(.inner(color: Color.black.opacity(0.3), radius: 4, x: -2, y: -2)))
                    .padding(.horizontal, 12)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(medicine.name)
                        .font(.headLine3)
                    
                    Text("\(medicine.frequency.filter({ $0.day.contains(Date().getDayOfWeek() ?? .Mon) }).map({ $0.type.value }).joined(separator: " "))")
                        .font(.body18)
                    
                    Text("\(medicine.frequency.filter { $0.day.contains(Date().getDayOfWeek() ?? .Mon)}.map({ $0.count }).reduce(0, +))tablet")
                        .font(.body18)
                }
                .foregroundStyle(.textBlack)
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 28)
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "checkmark")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(vm.containDoseList(medicine) ? Color.ML_Primary : Color.GrayAF.opacity(0.2))
                    .padding(.trailing, 32)
            }
            .whiteContent(width: 312, height: 144, bgColor: vm.containDoseList(medicine) ? .blue70 : .grayF6)
        }
    }
    
    private var sleepCycleView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 24) {
                Text("WAKE UP")
                    .font(.headLine3)
                    .foregroundStyle(.textBlack)
                
                Spacer(minLength: 10)
                DatePicker("", selection: $vm.todayRecord.sleepCycle.wakeupTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .tint(Color.ML_DarkBlue)
                    .font(.body18)
                    .labelsHidden()
                   
            }
            .frame(width: 240)
            .foregroundStyle(.textBlack)
            
            HStack(alignment: .center, spacing: 24) {
                Text("BEDTIME")
                    .font(.headLine3)
                    .foregroundStyle(.textBlack)
                Spacer(minLength: 10)
                DatePicker("", selection: $vm.todayRecord.sleepCycle.sleepTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .font(.body18)
                    .tint(Color.ML_DarkBlue)
                    .labelsHidden()
            }
            .frame(width: 240)
            .labelsHidden()
            .hView(.leading)
            .onChange(of: vm.todayRecord.sleepCycle) {
                vm.updateSleepCycle(vm.todayRecord.sleepCycle)
            }
        }
    }
    
    private var selectTimeView: some View {
        TimeControllView(selectedTime: $vm.selectedTime)
    }
    
    private var statusView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Status")
                .font(.headLine2)
                .foregroundStyle(.textBlack)
            
            HStack(spacing: 32) {
                ForEach(Status.allCases, id: \.hashValue) { status in
                    Button {
                        vm.toggleStatus(status)
                    } label: {
                        Text(status.rawValue)
                            .font(vm.containStatus(status) ? .button3B : .button3)
                            .foregroundStyle(vm.containStatus(status) ? Color.ML_DarkBlue :.textBlack)
                            .whiteContent(width: 172, height: 94, bgColor: vm.containStatus(status) ? .blue30 : .blue10)
                    }
                }
            }
        }
    }
    
    private var sideEffectView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Side Effects")
                .font(.headLine2)
            
            LazyHGrid(rows: [GridItem(.fixed(120)), GridItem(.fixed(120))], spacing: 32) {
                ForEach(SideEffect.allCases, id: \.rawValue) { effect in
                    Button {
                        vm.toggleSideEffect(effect)
                    } label: {
                        Text(effect.english)
                            .font(vm.containSideEffect(effect) ? .button3B : .button3)
                            .whiteContent(width: 160, height: 94, bgColor: vm.containSideEffect(effect) ? .blue30 : .blue10)
                    }
                }
            }
            .offset(y: -12)
        }
        .foregroundStyle(.textBlack)
    }
    
    private var memoWithPhotoVideo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Video")
                .font(.headLine2)
            
            HStack(spacing: 8) {
                VideoPickerView()
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(Array(vm.todayRecord.videos ?? []), id: \.hashValue) { url in
                            VideoView(movieUrl: url)
                        }
                    }
                }
            }
            
            Text("Memo")
                .font(.headLine2)
            
            TextField("Leave a note to record", text: $vm.todayRecord.memo)
                .font(.body20)
                .textFieldStyle(.plain)
                .onSubmit {
                    vm.leaveMemo(vm.todayRecord.memo)
                }
        }
        .foregroundStyle(.textBlack)
    }
}

#Preview {
    TodayView(vm: TodayViewModel())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
}
