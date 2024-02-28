//
//  MedicationView.swift
//  MeditationLog
//
//  Created by Lee Jinhee on 2/20/24.
//

import SwiftUI

struct MedicationView: View {
    @State var medicineList: [Medicine] = MedicineService.shared.medicineList
    @State var addButtonTapped: Bool = false
    @State var showTip: Bool = false
    let tipText: String = "In the Medication tab, you can add a medication\nyou are taking by pressing the + button."

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                Text("Medication")
                    .font(.title1B)
                
                Spacer()
                
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
                
                Button {
                    addButtonTapped = true
                } label: {
                    Image(systemName: "plus")
                        .font(.headLine2)
                        .foregroundStyle(Color.DarkBlue)
                }
            }
            
            ScrollView {
                VStack(spacing: 32) {
                    ForEach(medicineList, id: \.id) { medicine in
                        medicineView(medicine: medicine)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.top, 20)
                .padding(.bottom, 60)
            }
        }
        .padding(.top, 12)
        .padding(.horizontal, 28)
        .shadow(color: .GrayAF.opacity(0.1), radius: 14, x: 0, y: 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.GrayAF.opacity(0.08))
        .foregroundStyle(Color.TextBlack)
        
        .sheet(isPresented: $addButtonTapped, onDismiss: {
            medicineList = MedicineService.shared.medicineList
        }) {
            NavigationStack {
                AddMedicineSheetView(addButtonTapped: $addButtonTapped)
            }
        }
        .task {
            medicineList = MedicineService.shared.medicineList
        }
    }
    
    private func medicineView(medicine: Medicine) -> some View {
        HStack(alignment: .center, spacing: 24) {
            Circle().frame(width: 36, height: 36)
                .foregroundStyle(Color.white.shadow(.inner(color: Color.black.opacity(0.3), radius: 4, x: -2, y: -2)))
            
            HStack(spacing: 8) {
                Text(medicine.name)
                    .font(.headLine1)
                    .frame(width: 240)
                
                Spacer(minLength: 0)
                
                VStack(spacing: 20) {
                    ForEach(medicine.frequency.indices) { idx in
                        let fq = medicine.frequency[idx]
                        HStack(spacing: 12) {
                            Text("\(fq.day.map({ $0.rawValue }).joined(separator: " "))")
                                .font(.body20)
                                .frame(width: 140)
                            Text("\(fq.type.value)")
                                .font(.body20)
                                .frame(width: 140)
                            Text("**\(fq.count)** Tablet")
                                .font(.body18)
                                .frame(width: 68)
                        }
                    }
                }
            }
            .foregroundStyle(Color.TextBlack)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 24)
        .foregroundStyle(Color.TextBlack)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.clear)
                .background(Color.white.opacity(1))
                .cornerRadius(20)
        )
    }
}

#Preview {
    MedicationView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Background)
}
