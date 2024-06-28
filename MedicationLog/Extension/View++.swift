//
//  SwiftUIView.swift
//  
//
//  Created by Lee Jinhee on 2/18/24.
//

import SwiftUI

extension View {
    func hView(_ alignment: Alignment, _ paddingValue: CGFloat = 0) -> some View {
        HStack {
            if alignment == .trailing {
                Spacer(minLength: 0)
            }
            self
            if alignment == .leading {
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, paddingValue)
    }
    
    func whiteContent(width: CGFloat, height: CGFloat, fgColor: BackgroundColor = .textBlack, bgColor: BackgroundColor = .white70) -> some View {
        modifier(WhiteContentView(width: width, height: height, fgColor: fgColor, bgColor: bgColor))
    }
    
    
    @ViewBuilder func changeTextColor(_ color: Color) -> some View {
        if UITraitCollection.current.userInterfaceStyle == .light {
            self.colorInvert().colorMultiply(color)
        } else {
            self.colorMultiply(color)
        }
    }
  
    func asUiImage() -> UIImage {
        var uiImage = UIImage(systemName: "exclamationmark.triangle.fill")!
        let controller = UIHostingController(rootView: self)
        
        if let view = controller.view {
            let contentSize = view.intrinsicContentSize
            view.bounds = CGRect(origin: .zero, size: contentSize)
            view.backgroundColor = .clear
            
            let renderer = UIGraphicsImageRenderer(size: contentSize)
            uiImage = renderer.image { _ in
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            }
        }
        return uiImage
    }
}
