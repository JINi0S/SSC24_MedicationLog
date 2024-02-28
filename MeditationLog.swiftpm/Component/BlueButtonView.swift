//
//  BlueButtonView.swift
//
//
//  Created by Lee Jinhee on 2/19/24.
//

import SwiftUI

struct BlueLabelView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.button1)
            .padding(.vertical, 16)
            .padding(.horizontal, 40)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(
                        .shadow(.inner(color: .DarkBlue.opacity(0.5), radius: 2, x: -6, y: -10))
                        .shadow(.inner(color: .white.opacity(0.4), radius: 6, x: 10, y: 8))
                    )
                    .foregroundStyle(Color.Primary)
            )
    }
}

struct BlueButtonView: View {
    let text: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            BlueLabelView(text: text)
        }
    }
}

#Preview {
    BlueButtonView(text: "BlueButton", action: {})
}
