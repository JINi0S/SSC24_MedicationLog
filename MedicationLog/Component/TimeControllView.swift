//
//  TimeControllView.swift
//  
//
//  Created by Lee Jinhee on 2/28/24.
//

import SwiftUI

struct TimeControllView: View {
    
    @State private var startIndex = 0
    @Binding var selectedTime: Int
    
    private let hoursOfDay = Array(0...23)

    var body: some View {
        HStack(spacing: 8) {
            Button {
                withAnimation {
                    startIndex = max(0, startIndex - 1)
                }
            } label: {
                imageView(name: "chevron.left")
            }
            
            timeView
            
            Button {
                withAnimation {
                    startIndex = min(hoursOfDay.count/6 - 1, startIndex + 1)
                }
            } label: {
                imageView(name: "chevron.right")
            }
        }
        .task {
            startIndex =  selectedTime / 6
        }
    }
    
    private func imageView(name: String) -> some View {
        Image(systemName: name)
            .font(.headLine1)
            .foregroundStyle(Color.GrayAF.opacity(0.5))
    }
    
    private var timeView: some View {
        TabView(selection: $startIndex) {
            ForEach(0..<(hoursOfDay.count / 6), id: \.self) { index in
                let range = index * 6..<min((index + 1) * 6, hoursOfDay.count)
                HStack(spacing: 20) {
                    ForEach(range, id: \.self) { idx in
                        btnView(idx: idx)
                    }
                }
                .tag(index)
            }
        }
        .frame(height: 50)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.GrayAF.opacity(0.1))
                .frame(height: 50)
        )
    }
    
    private func btnView(idx: Int) -> some View {
        Button(action: {
            selectedTime = idx
        }) {
            let isSameTime = selectedTime == idx

            Text("\(hoursOfDay[idx]):00")
                .frame(width: 80, height: 50)
                .font(isSameTime ? .button2B : .button2)
                .foregroundColor(isSameTime ? .textBlack : Color.GrayAF)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(isSameTime ? Color.ML_Primary.opacity(0.5) : .clear)
                        .frame(height: 50)
                )
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TimeControllView(selectedTime: .constant(1))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ML_Background)
}
