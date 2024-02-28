//
//  LogView.swift
//  MeditationLog
//
//  Created by Lee Jinhee on 2/19/24.
//

import SwiftUI
import Photos

enum LogType: String, CaseIterable {
    case Day
    case Week
    case Month
}

struct LogView: View {
    @ObservedObject var vm: LogViewModel
    
    @State private var showingAlert: Bool = false
    @State private var showingDeniedAlert: Bool = false
    
    @State var showTip: Bool = false
    let tipText: String = "The Log tab organizes and displays the logs\nfrom the Today tab by day, week, and month.\nWe have arbitrarily entered data\nfrom the previous day and the day before that,\nso feel free to refer to them!\n\nYou can also save the log as an image by clicking the right button."
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                Text("Log")
                    .font(.title1B)
                
                Spacer(minLength: 0)
                
                Button{
                    showTip.toggle()
                } label: {
                    Image(systemName: "questionmark.circle")
                        .font(.headLine2)
                        .foregroundStyle(Color.DarkBlue)
                    
                }
                .popover(isPresented: $showTip, arrowEdge: .bottom) {
                    Text(tipText)
                        .padding()
                        .foregroundStyle(Color.TextBlack)
                }
                
                exportView
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    /// 선택
                    typeSelectView
                    
                    periodSelectView
                    
                    /// 기록
                    if vm.selectedType == .Day {
                        MedicationRecordView(vm: vm)
                    }
                    recordedSideEffectsView
                    
                    recordedVideoView
                    
                    recordedMemoView
                }
                .padding(.bottom, 60)
            }
            .task {
                vm.fetchSelectedDayRecord()
                vm.fetchSelectedDayRecordList()
            }
        }
        .padding(.top, 12)
        .padding(.horizontal, 28)
        .shadow(color: .GrayAF.opacity(0.1), radius: 14, x: 0, y: 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(Color.TextBlack)
        .background(Color.white)
        
        .alert("Saved", isPresented: $showingAlert) {
            Button("OK") {  showingAlert = false }
        } message: {
            Text("The Log has been saved in Photos.")
        }
        
        .alert("You didn't allow to access photos album", isPresented: $showingDeniedAlert) {
            Button {
                if let url = URL(string: "App-Prefs:root=General&path=About") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                showingDeniedAlert = false
            } label: {
                Text("Open Setting")
            }
            
            Button(role: .cancel) {
                showingDeniedAlert = false
            } label: {
                Text("Cancel")
            }
        } message: {
            Text("The log didn't saved. \n Please allow access to the photos album in the Settings app.")
        }
    }
    
    private var exportView: some View {
        Button {
            //MARK: Save image
            let totalDetailViewimage = LogView(vm: vm).asUiImage()
            PHPhotoLibrary.requestAuthorization( { status in
                switch status {
                case .authorized :
                    UIImageWriteToSavedPhotosAlbum(totalDetailViewimage, self, nil, nil)
                    showingAlert = true
                case .denied, .limited, .restricted, .notDetermined:
                    showingDeniedAlert = true
                default:
                    showingDeniedAlert = true
                }
            })
        } label: {
            Image(systemName: "square.and.arrow.down")
                .font(.headLine2)
                .foregroundStyle(Color.DarkBlue)
        }
    }
    
    private var typeSelectView: some View {
        HStack(spacing: 12) {
            ForEach(LogType.allCases, id: \.rawValue) { log in
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
                        .foregroundStyle(selected ? Color.TextBlack : Color.TextBlack.opacity(0.7))
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
                case .Day:
                    vm.selectedDate = vm.selectedDate.previousDay()
                case .Week:
                    vm.selectedDateList = vm.selectedDateList.0.previousWeekRange()
                case .Month:
                    vm.selectedDateList = vm.selectedDateList.0.previousMonthRange()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headLine3)
            }
            
            Group {
                switch vm.selectedType {
                case .Day:
                    Text("\(vm.selectedDate.toString(format: "MM/dd/yy"))")
                case .Week, .Month:
                    Text("\(vm.selectedDateList.0.toString(format: "MM/dd/yy")) ~ \(vm.selectedDateList.1.toString(format: "MM/dd/yy"))")
                }
            }
            .font(.headLine2)
            
            Button {
                switch vm.selectedType {
                case .Day:
                    vm.selectedDate = vm.selectedDate.nextDay()
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
        .foregroundStyle(Color.TextBlack)
    }
    
    private var recordedSideEffectsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recorded side effects")
                .font(.headLine2)
            
            switch vm.selectedType {
            case .Day:
                if let sideEffects = vm.selectedDayRecord?.sideEffects, (sideEffects.filter({ $0.count != 0 }).count >= 1) {
                    VStack(spacing: 8) {
                        ForEach(Array(sideEffects.enumerated()), id: \.offset) { index, effects in
                            effectsView(effects: effects, index: index, date: vm.selectedDayRecord?.date ?? .now)
                        }
                        .foregroundStyle(Color.TextBlack)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color.Primary.opacity(0.10))
                    )
                } else {
                    noRecordedView(title: "There are no recorded side effects.")
                }
            case .Week, .Month:
                if let recordList = vm.selectedDayRecordList, !recordList.isEmpty {
                    let effectsDTOList = RecordService.shared.sideEffectsDTO(from: recordList).sorted { $0.date < $1.date }
                    VStack(spacing: 8) {
                        ForEach(effectsDTOList, id: \.date) { effectsDTO in
                            ForEach(Array(effectsDTO.sideEffects.enumerated()), id: \.offset) { idx, effects in
                                if !effects.isEmpty {
                                    effectsView(effects: effects, index: idx, date: effectsDTO.date)
                                }
                            }
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color.Primary.opacity(0.10))
                    )
                } else {
                    noRecordedView(title: "There are no recorded side effects.")
                }
            }
        }
    }
    
    private var recordedVideoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recorded video")
                .font(.headLine2)
            
            switch vm.selectedType {
            case .Day:
                if let videos = vm.selectedDayRecord?.videos, !videos.isEmpty {
                    ScrollView {
                        HStack(spacing: 8) {
                            ForEach(Array(videos.enumerated()), id: \.offset) { index, url in
                                VideoView(movieUrl: url)
                            }
                        }
                    }
                } else {
                    noRecordedView(title: "There are no recorded videos.")
                }
            case .Week, .Month:
                if let recordList = vm.selectedDayRecordList, !recordList.isEmpty {
                    let effectsDTOList = RecordService.shared.videoUrlDTO(from: recordList).sorted { $0.date < $1.date }
                    if effectsDTOList.isEmpty {
                        noRecordedView(title: "There are no recorded videos.")
                    } else {
                        VStack {
                            ForEach(effectsDTOList, id: \.date) { effectsDTO in
                                ScrollView(.horizontal) {
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("\(effectsDTO.date.toString())")
                                        ForEach(Array(effectsDTO.urls), id: \.hashValue) { url in
                                            VideoView(movieUrl: url)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    noRecordedView(title: "There are no recorded videos.")
                }
            }
        }
        .font(.body18)
    }
    
    private var recordedMemoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recorded memo")
                .font(.headLine2)
            switch vm.selectedType {
            case .Day:
                if let memo = vm.selectedDayRecord?.memo, memo != "" {
                    HStack {
                        Text(memo)
                            .padding(24)
                        
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color.Primary.opacity(0.10))
                    )
                } else {
                    noRecordedView(title: "There are no recorded memos.")
                }
            case .Week, .Month:
                if let recordList = vm.selectedDayRecordList, !recordList.isEmpty {
                    let memoDTOList = RecordService.shared.memoDTO(from: recordList).sorted { $0.date < $1.date }
                    if memoDTOList.isEmpty {
                        noRecordedView(title: "There are no recorded memos.")
                    } else {
                        VStack(spacing: 14) {
                            ForEach(memoDTOList, id: \.date) { memoDTO in
                                HStack {
                                    Text("\(memoDTO.date.toString())")
                                        .padding(.horizontal, 24)
                                    Text(memoDTO.memo)
                                    
                                    Spacer(minLength: 0)
                                }
                            }
                        }
                        .padding(.all, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color.Primary.opacity(0.10))
                        )
                    }
                } else {
                    noRecordedView(title: "There are no recorded memos.")
                }
            }
        }
        .font(.body18)
    }
    
    fileprivate func noRecordedView(title: String) -> some View {
        Text(title)
            .padding(32)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.GrayAF)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.GrayAF.opacity(0.10))
            )
    }
    
    fileprivate func effectsView(effects: [SideEffect], index: Int, date: Date) -> some View {
        Group {
            if !effects.isEmpty {
                HStack(spacing: 0) {
                    switch vm.selectedType {
                    case .Day:
                        Spacer().frame(width: 0, height: 0)
                    case .Week, .Month:
                        Text("\(date.toString())")
                            .font(.footnote16)
                            .frame(width: 82)
                            .padding(.trailing, 30)
                    }
                    
                    Text("\(index):00")
                        .frame(width: 58)
                        .padding(.trailing, 30)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(effects, id: \.rawValue) { effect in
                                effectTagView(effect: effect)
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func effectTagView(effect: SideEffect) -> some View {
        Text("\(effect.english)")
            .font(.headLine4)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .foregroundStyle(Color.Primary.opacity(0.3))
            )
    }
}

#Preview {
    LogView(vm: LogViewModel())
}


struct MedicationRecordView: View {
    @ObservedObject var vm: LogViewModel
    @State private var popoverTxt: String = ""
    @State private var showPopoverA: Bool = false
    @State private var showPopoverB: Bool = false
    
    private let hoursOfDay = Array(0...23)
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Medication Record")
                .font(.headLine2)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Time")
                        .frame(width: 40)
                    HStack {
                        ForEach(MedicineService.shared.medicineList, id: \.name) { medicine in
                            Text("\(medicine.name)")
                                .frame(minWidth: 80)
                                .frame(height: 30)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Group {
                        Text("Effective")
                        Text("Ineffective")
                        Text("Twisted")
                    }
                    .frame(width: 120)
                }
                .font(.headLine4)
                
                recordView
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color.Primary.opacity(0.1))
        )
    }
    
    private var recordView: some View {
        VStack (spacing: 4) {
            ForEach(hoursOfDay, id: \.self) { hour in
                HStack {
                    if let selectedRecord = vm.selectedDayRecord,
                        selectedRecord.sleepCycle.isTimeBetweenWakeupAndSleep(hour: hour) {
                            Text("\(hour)")
                                .frame(width: 40)
                                .font(.headLine4)
                                .foregroundStyle(Color.Primary)
                    } else {
                        Text("\(hour)")
                            .frame(width: 40)
                            .font(.headLine4)
                    }
                    
                    HStack {
                        Group {
                            ForEach(MedicineService.shared.medicineList, id: \.id) { medicine in
                                if let selectedRecord = vm.selectedDayRecord,
                                   let doseList = selectedRecord.doseList[safe: hour],
                                   doseList.contains(where: { $0.name == medicine.name }) {
                                    Text("💊")
                                        .frame(minWidth: 80)
                                } else {
                                    Text("-")
                                        .frame(minWidth: 80)
                                }
                            }
                        }
                    }
                    .font(.button4)
                    .frame(maxWidth: .infinity)
                    
                    Group {
                        Text("\((vm.selectedDayRecord != nil && vm.selectedDayRecord!.status[hour].contains(where: { $0 == Status.Effective })) ? "O" : "-")") // 약효 있음
                        Text("\((vm.selectedDayRecord != nil && vm.selectedDayRecord!.status[hour].contains(where: { $0 == Status.Ineffective })) ? "X" : "-")")  // 약효 없음
                        Text("\((vm.selectedDayRecord != nil && vm.selectedDayRecord!.status[hour].contains(where: { $0 == Status.Twisted })) ? "🔺" : "-")")
                    }
                    .frame(width: 120)
                    .font(.button4)
                }
                
                Divider().foregroundStyle(Color.DarkBlue.opacity(0.5))
            }
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
