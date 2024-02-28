//
//  StartView.swift
//  MeditationLog
//
//  Created by Lee Jinhee on 2/18/24.
//

import SwiftUI

struct StartView: View {
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 70) {
                VStack {
                    Image("Title")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 720)
                    Image("Subtitle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 420)
                        .offset(x: 90)
                }
                
                HStack(alignment: .bottom) {
                    Image("Snowman")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 440)
                    
                    Spacer(minLength: 30)
                    
                    NavigationLink {
                        OnboardingView()
                    } label: {
                        BlueLabelView(text: "Let's Start")
                    }
                    .padding(.bottom, 40)
                }
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.Background)
        }
    }
}

#Preview {
    StartView()
}
