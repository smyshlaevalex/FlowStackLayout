//
//  FlowStackLayout.swift
//
//
//  Created by Alexander Smyshlaev on 30.06.2022.
//

import SwiftUI

public struct FlowStackLayoutResult {
    let containerSize: CGSize
    let subviewPositions: [CGPoint]
}

public struct FlowStackLayout: Layout {
    private let alignment: Alignment
    private let horizontalSpacing: Double?
    private let verticalSpacing: Double?
    
    public init(alignment: Alignment = .center, horizontalSpacing: Double? = nil, verticalSpacing: Double? = nil) {
        self.alignment = alignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }
    
    public func makeCache(subviews: Subviews) -> FlowStackLayoutResult {
        FlowStackLayoutResult(containerSize: .zero, subviewPositions: [])
    }
    
    public func updateCache(_ cache: inout FlowStackLayoutResult, subviews: Subviews) {
        cache = FlowStackLayoutResult(containerSize: .zero, subviewPositions: [])
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout FlowStackLayoutResult) -> CGSize {
        cache = layout(maxWidth: proposal.replacingUnspecifiedDimensions().width, subviews: subviews)
        return cache.containerSize
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout FlowStackLayoutResult) {
        for (subview, subviewPosition) in zip(subviews, cache.subviewPositions) {
            subview.place(at: CGPoint(x: bounds.minX + subviewPosition.x,
                                      y: bounds.minY + subviewPosition.y),
                          proposal: proposal)
        }
    }
    
    private func layout(maxWidth: CGFloat, subviews: Subviews) -> FlowStackLayoutResult {
        var containerSize: CGSize = .zero
        var currentSubviewPosition: CGPoint = .zero
        var previousHorizontalViewSpacing: ViewSpacing?
        var verticalViewSpacing = ViewSpacing()
        var subviewFrameRows: [[CGRect]] = []
        var currentSubviewFrameRow: [CGRect] = []
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            let horizontalSpacing = previousHorizontalViewSpacing.flatMap {
                self.horizontalSpacing ?? subview.spacing.distance(to: $0, along: .horizontal)
            } ?? 0
            previousHorizontalViewSpacing = subview.spacing
            
            let subviewWidthAndSpacing = size.width + horizontalSpacing
            
            let newContainerWidth = currentSubviewPosition.x + subviewWidthAndSpacing
            if newContainerWidth <= maxWidth {
                currentSubviewPosition.x += horizontalSpacing
                
                currentSubviewFrameRow.append(CGRect(origin: currentSubviewPosition, size: size))
                
                containerSize.width = max(containerSize.width, newContainerWidth)
                currentSubviewPosition.x += size.width
                
                verticalViewSpacing.formUnion(subview.spacing)
                
                let newContainerHeight = currentSubviewPosition.y + size.height
                containerSize.height = max(containerSize.height, newContainerHeight)
            } else {
                currentSubviewPosition.x = 0
                currentSubviewPosition.y = containerSize.height
                
                let verticalSpacing = self.verticalSpacing ?? subview.spacing.distance(to: verticalViewSpacing, along: .vertical)
                verticalViewSpacing = ViewSpacing()
                
                currentSubviewPosition.y += verticalSpacing
                
                subviewFrameRows.append(currentSubviewFrameRow)
                currentSubviewFrameRow = []
                currentSubviewFrameRow.append(CGRect(origin: currentSubviewPosition, size: size))
                
                let newContainerHeight = currentSubviewPosition.y + size.height
                containerSize.height = max(containerSize.height, newContainerHeight)
                
                containerSize.width = max(containerSize.width, size.width)
                
                currentSubviewPosition.x += size.width
            }
        }
        
        subviewFrameRows.append(currentSubviewFrameRow)
        currentSubviewFrameRow = []
        
        subviewFrameRows = subviewFrameRows.map { rowFrames in
            let trailingSpacing = containerSize.width - (rowFrames.last?.maxX ?? 0)
            let rowHeight = rowFrames.max(by: { $0.height < $1.height })?.height ?? 10
            let xOffset: CGFloat
            switch alignment.horizontal {
            case .leading:
                xOffset = 0
                
            case .center:
                xOffset = trailingSpacing / 2
                
            case .trailing:
                xOffset = trailingSpacing
                
            default:
                xOffset = 0
            }
            
            return rowFrames.map { frame in
                let yOffset: CGFloat
                switch alignment.vertical {
                case .top:
                    yOffset = 0
                    
                case .center:
                    yOffset = (rowHeight - frame.height) / 2
                    
                case .bottom:
                    yOffset = rowHeight - frame.height
                    
                default:
                    yOffset = 0
                }
                
                return frame.offsetBy(dx: xOffset, dy: yOffset)
            }
        }
        
        let subviewPositions = subviewFrameRows.flatMap { $0 } .map(\.origin)
        
        return FlowStackLayoutResult(containerSize: containerSize, subviewPositions: subviewPositions)
    }
}
