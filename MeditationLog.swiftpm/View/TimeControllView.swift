//
//  TimeControllView.swift
//  
//
//  Created by Lee Jinhee on 2/28/24.
//

import SwiftUI

struct TimeControllView: View {
    let hoursOfDay = Array(0...23)
    
    @State private var startIndex = 0
    @Binding var selectedTime: Int
    
    var body: some View {
        
        HStack(spacing: 8) {
            Button {
                withAnimation {
                    startIndex = max(0, startIndex - 1)
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headLine1)
                    .foregroundStyle(Color.GrayAF.opacity(0.5))
            }
            
            TabView(selection: $startIndex) {
                ForEach(0..<(hoursOfDay.count / 6), id: \.self) { index in
                    let range = index * 6..<min((index + 1) * 6, hoursOfDay.count)
                    HStack(spacing: 20) {
                        ForEach(range, id: \.self) { idx in
                            Button(action: {
                                selectedTime = idx
                            }) {
                                Text("\(hoursOfDay[idx]):00")
                                    .frame(width: 80, height: 50)
                                    .font(selectedTime == idx ? .button2B : .button2)
                                    .foregroundColor(selectedTime == idx ? Color.TextBlack : Color.GrayAF)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 24)
                                            .foregroundStyle(selectedTime == idx ? Color.Primary.opacity(0.5) : .clear)
                                            .frame(height: 50)
                                    )
                            }
                            .frame(maxWidth: .infinity)
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
            
            Button {
                withAnimation {
                    startIndex = min(hoursOfDay.count/6 - 1, startIndex + 1)
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.headLine1)
                    .foregroundStyle(Color.GrayAF.opacity(0.5))
            }
        }
        .task {
            startIndex =  selectedTime / 6
        }
    }
}

#Preview {
    TimeControllView(selectedTime: .constant(1))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Background)
}
