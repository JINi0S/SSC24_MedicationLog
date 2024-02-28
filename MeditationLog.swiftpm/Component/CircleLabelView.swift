//
//  SwiftUIView.swift
//  
//
//  Created by Lee Jinhee on 2/20/24.
//

import SwiftUI

struct CircleLabelView: View {
    let text: String
    let size: CGFloat = 44
    var isAble: Bool
    var body: some View {
        Circle()
            .frame(width: size, height: size)
            .foregroundStyle(isAble ? Color.Primary.opacity(0.7) : Color.Primary.opacity(0.2))
            .overlay {
                Text(text)
                    .foregroundStyle(Color.DarkBlue)
                    .font(isAble ? .button4B : .button4)
            }
    }
}

#Preview {
    VStack {
        CircleLabelView(text: "AB", isAble: true)
        CircleLabelView(text: "DAB", isAble: false)
    }
}
