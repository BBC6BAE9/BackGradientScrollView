//
//  BackGridientScrollView.swift
//  ScrollDemo
//
//  Created by hong on 2024/7/19.
//  Copyright © 2024 Fooman Inc. All rights reserved.
//

import SwiftUI

struct BackGridientScrollView<Content: View>: View {
    
    var backgroundColor:Color = .white
    
    var pic:URL?
    
    var height:CGFloat
    
    var content: () -> Content
    
    @State private var verticalOffset: CGFloat = 0.0
    
    var body: some View {
        
        OffsettableScrollView { point in
            verticalOffset = point.y
        } content: {
            content()
                .frame(maxWidth: .infinity)
        }
        .background(
            BackGridientView(color:backgroundColor ,height: height, offset: $verticalOffset, pic: pic)
        )
    }
}

private struct OffsettableScrollView<T: View>: View {
    let axes: Axis.Set
    let showsIndicator: Bool
    let onOffsetChanged: (CGPoint) -> Void
    let content: T
    
    init(axes: Axis.Set = .vertical,
         showsIndicator: Bool = true,
         onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
         @ViewBuilder content: () -> T
    ) {
        self.axes = axes
        self.showsIndicator = showsIndicator
        self.onOffsetChanged = onOffsetChanged
        self.content = content()
    }
    
    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicator) {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: OffsetPreferenceKey.self,
                    value: proxy.frame(
                        in: .named("ScrollViewOrigin")
                    ).origin
                )
            }
            .frame(width: 0, height: 0)
            content
        }
        .coordinateSpace(name: "ScrollViewOrigin")
        .onPreferenceChange(OffsetPreferenceKey.self,
                            perform: onOffsetChanged)
    }
}

private struct OffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}
