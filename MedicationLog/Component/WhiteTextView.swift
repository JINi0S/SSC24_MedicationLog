//
//  WhiteTextView.swift
//
//
//  Created by Lee Jinhee on 2/19/24.
//

import SwiftUI

struct WhiteTextView: View {
    let text: String
    var radius: CGFloat = 20
    
    var width: CGFloat = 200
    var height: CGFloat = 112
    
    var body: some View {
        Text(text)
            .font(.headLine2)
            .foregroundStyle(Color.ML_Primary)
            .frame(width: width, height: height)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.clear)
                    .frame(width: width, height: height)
                    .background(.white.opacity(0.3))
                    .cornerRadius(radius)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .inset(by: 0.5)
                            .stroke(.white, lineWidth: 1)
                    )
            )
    }
}

struct WhiteContentView: ViewModifier {
    var width: CGFloat = 230
    var height: CGFloat = 120
    
    let fgColor: BackgroundColor
    let bgColor: BackgroundColor
    
    public func body(content: Content) -> some View {
        content
            .foregroundStyle(fgColor.color)
            .frame(width: width, height: height)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.clear)
                    .frame(width: width, height: height)
                    .background(bgColor.color)
                    .cornerRadius(20)
            )
    }
}

#Preview {
    VStack {
        WhiteTextView(text: "Text", radius: 20, width: 230, height: 120)
    }
    .padding(100)
    .background(Color.ML_Primary)
}

enum BackgroundColor: ShapeStyle {
    case white
    case white10
    case white30
    case white40
    case white50
    case white70
    case blue10
    case blue30
    case blue50
    case blue70
    case grayAF
    case grayF6
    case textBlack
    case none
    
    var color: Color {
        switch self {
        case .white:
            Color.white
        case .white10:
            Color.white.opacity(0.1)
        case .white30:
            Color.white.opacity(0.3)
        case .white40:
            Color.white.opacity(0.4)
        case .white50:
            Color.white.opacity(0.5)
        case .white70:
            Color.white.opacity(0.7)
        case .blue10:
            Color.ML_Primary.opacity(0.1)
        case .blue30:
            Color.ML_Primary.opacity(0.3)
        case .blue50:
            Color.ML_Primary.opacity(0.5)
        case .blue70:
            Color.ML_Primary.opacity(0.5)
        case .grayAF:
            Color.GrayAF
        case .grayF6:
            Color.GrayF6
        case .textBlack:
            .textBlack
        case .none:
            Color.clear
        }
    }
}
