//
//  Font++.swift
//  MeditationLog
//
//  Created by Lee Jinhee on 2/18/24.
//

import SwiftUI

enum AppFont: String {
    case regular = "Pretendard-Regular"
    case bold = "Pretendard-Bold"
    case semiBold = "Pretendard-SemiBold"
}

extension Font {
    static let onboardingHeadlineB: Font =  .system(size: 22, weight: .black)
    
    static let title1B: Font = .system(size: 36, weight: .heavy)
    static let title2B: Font = .system(size: 28, weight: .bold)

    static let headLine1: Font =  .system(size: 24, weight: .semibold)
    static let headLine2: Font =  .system(size: 20, weight: .semibold)
    static let headLine3: Font =  .system(size: 18, weight: .semibold)
    static let headLine4: Font =  .system(size: 16, weight: .semibold)
    static let headLine5: Font =  .system(size: 14, weight: .semibold)

    static let headLine1B: Font =  .system(size: 24, weight: .bold)
    
    static let button1: Font = .system(size: 40, weight: .semibold)
    static let button2: Font = .system(size: 18, weight: .regular)
    static let button2B: Font = .system(size: 20, weight: .bold)
    
    static let button3: Font = .system(size: 20, weight: .regular)
    static let button3B: Font = .system(size: 20, weight: .bold)
    
    static let button4: Font = .system(size: 14, weight: .regular)
    static let button4B: Font = .system(size: 14, weight: .bold)

    static let body20: Font = .system(size: 20, weight: .regular)
    static let body18: Font = .system(size: 18, weight: .regular)
    
    static let footnote16: Font = .system(size: 16, weight: .regular)
}
