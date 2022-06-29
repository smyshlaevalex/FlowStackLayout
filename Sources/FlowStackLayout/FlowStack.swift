//
//  FlowStack.swift
//  
//
//  Created by Alexander Smyshlaev on 30.06.2022.
//

import SwiftUI

public struct FlowStack<Content: View>: View {
    private let alignment: Alignment
    private let horizontalSpacing: Double?
    private let verticalSpacing: Double?
    private let content: () -> Content
    
    public init(alignment: Alignment = .center,
                horizontalSpacing: Double? = nil,
                verticalSpacing: Double? = nil,
                @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.content = content
    }
    
    public var body: some View {
        FlowStackLayout(alignment: alignment, horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing) {
            content()
        }
    }
}
