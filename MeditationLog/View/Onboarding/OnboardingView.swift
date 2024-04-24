//
//  OnboardingView.swift
//  MeditationLog
//
//  Created by Lee Jinhee on 2/19/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selection: Int = 1
    
    var body: some View {
        VStack {
            TabView(selection: $selection) {
                Onboarding1View().tag(1)
                Onboarding2View().tag(2)
                Onboarding3View().tag(3)
            }
            .tabViewStyle(.page)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.ML_Background)
            .overlay(alignment: .bottomTrailing){
                Group {
                    if selection == 3 {
                        NavigationLink {
                            TabRouteView()
                        } label: {
                            BlueLabelView(text: "Let's Start")
                        }
                    } else {
                        BlueButtonView(text: "Next") {
                            selection += 1
                        }
                    }
                }
                .padding(.all, 32)
            }
        }
    }
}

#Preview {
    OnboardingView()
}

struct Onboarding1View: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            Text("\(LocalizedStringKey.Onboarding1.title.eng)")
                .font(.title1B)
                .foregroundStyle(Color.ML_DarkBlue)

            Text("\(LocalizedStringKey.Onboarding1.content.eng)")
                .font(.headLine2)
                .lineSpacing(4)
                .foregroundStyle(.textBlack)
                .padding(.horizontal, 22)
                .padding(.vertical, 28)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 32)
                        .foregroundStyle(Color.white.opacity(0.6))
                )
            
            VStack(alignment: .center, spacing: 20) {
                HStack(spacing: 36) {
                    WhiteTextView(text: LocalizedStringKey.Onboarding1.example1.eng, width: 344, height: 100)
                    WhiteTextView(text: LocalizedStringKey.Onboarding1.example2.eng, width: 344, height: 100)
                } .frame(maxHeight: .infinity)
                
                HStack(spacing: 36) {
                    WhiteTextView(text: LocalizedStringKey.Onboarding1.example3.eng, width: 344, height: 100)
                    WhiteTextView(text: LocalizedStringKey.Onboarding1.example4.eng, width: 344, height: 100)
                }
                .frame(maxHeight: .infinity)
                
                WhiteTextView(text: LocalizedStringKey.Onboarding1.example5.eng, width: 344, height: 100)
                    .frame(maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer(minLength: 0)
        }
        .padding(40)
    }
}


struct Onboarding2View: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(LocalizedStringKey.Onboarding2.title.eng)")
                .font(.title1B)
                .foregroundStyle(Color.ML_DarkBlue)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("\(LocalizedStringKey.Onboarding2.content.eng)")
                    .font(.headLine2).lineSpacing(6)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(LocalizedStringKey.Onboarding2.example1.eng)")
                        .font(.onboardingHeadlineB)
                        .foregroundStyle(Color.ML_DarkBlue)
                    Text("\(LocalizedStringKey.Onboarding2.example1_1.eng)")
                        .font(.headLine3)
                        .padding(.bottom, 18)
                    
                    Text("\(LocalizedStringKey.Onboarding2.example2.eng)")
                        .font(.onboardingHeadlineB)
                        .foregroundStyle(Color.ML_DarkBlue)
                    Text("\(LocalizedStringKey.Onboarding2.example2_1.eng)")
                        .font(.headLine3)
                        .padding(.bottom, 18)
                    
                    Text("\(LocalizedStringKey.Onboarding2.example3.eng)")
                        .font(.onboardingHeadlineB)
                        .foregroundStyle(Color.ML_DarkBlue)

                    Text("\(LocalizedStringKey.Onboarding2.example3_1.eng)")
                        .font(.headLine3)
                        .padding(.bottom, 18)
                    
                    Text("\(LocalizedStringKey.Onboarding2.example4.eng)")
                        .font(.onboardingHeadlineB)
                        .foregroundStyle(Color.ML_DarkBlue)

                    Text("\(LocalizedStringKey.Onboarding2.example4_1.eng)")
                        .font(.headLine3)
                }
            }
            .foregroundStyle(.textBlack)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 36)
            .padding(.vertical, 22)
            .hView(.leading)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .foregroundStyle(Color.white.opacity(0.6))
            )
            
            Spacer(minLength: 0)
        }
        .padding(40)
    }
}

struct Onboarding3View: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            Text("\(LocalizedStringKey.Onboarding3.title.eng)")
                .font(.title1B)
                .foregroundStyle(Color.ML_DarkBlue)

            VStack(alignment: .leading, spacing: 40) {
                Text("\(LocalizedStringKey.Onboarding3.content.eng)")
                    .font(.headLine3)
                    .bold()
                VStack(alignment: .leading, spacing: 24) {
                    Text("\(LocalizedStringKey.Onboarding3.example1.eng)")
                    Text("\(LocalizedStringKey.Onboarding3.example2.eng)")
                    Text("\(LocalizedStringKey.Onboarding3.example3.eng)")
                }
                .lineSpacing(6)
                .font(.headLine2)
            }
            .foregroundStyle(.textBlack)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 36)
            .padding(.vertical, 32)
            
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .foregroundStyle(Color.white.opacity(0.6))
            )
            .hView(.leading)
            
            
            VStack(spacing: 16) {
                Text("‼️ Before you start ‼️")
                    .font(.headLine1)
                Text("You can check the information about each tab\nby clicking the question mark button in the upper right corner of each tab.")
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(.textBlack)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 36)
            .padding(.vertical, 32)
            .font(.headLine2)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .foregroundStyle(Color.ML_Primary.opacity(0.3))
            )
            
            Spacer(minLength: 0)
        }
        .padding(40)
    }
}
