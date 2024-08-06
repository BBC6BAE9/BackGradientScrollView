//
//  BackGridientView.swift
//  ScrollDemo
//
//  Created by hong on 2024/7/19.
//  Copyright © 2024 Fooman Inc. All rights reserved.
//

import SwiftUI
import Kingfisher

struct BackGridientView: View {
    
    var color: Color
    var height: CGFloat
    @Binding var offset: CGFloat
    var pic:URL?
    @State var themeColor: Color = .clear
    
    init(color: Color = .clear, height: CGFloat, offset: Binding<CGFloat>, pic:URL?) {
        self.color = color
        self.height = height
        self._offset = offset
        self.pic = pic
    }
    
    var body: some View {
        VStack{
            KFImage(pic)
                .centerCropped()
                .frame(height: height)
                .overlay(content: {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            themeColor.opacity(1),
                            themeColor.opacity(0.65),
                            themeColor.opacity(0),
                            themeColor.opacity(0),
                            themeColor.opacity(0),
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing)
                })
                .mask {
                    LinearGradient(gradient: Gradient(stops: [
                        Gradient.Stop(color: Color.clear, location: 0),
                        Gradient.Stop(color: color, location: 0.4)
                    ]), startPoint: .bottom, endPoint: .top)
                }
                .scaleEffect(scale())
                .opacity(1.0 + (offset / height))
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .background(color)
        
    }
    
    /// 计算缩放比例
    private func scale() -> Double {
        guard offset > 0 else {
            return 1.0
        }
        let targetScale = 1.0 + offset / height
        return targetScale
    }
}

extension KFImage {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}
