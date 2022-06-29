# FlowStackLayout

`FlowStack` acts like a `HStack` until there are no more space for new cells, then `FlowStack` will wrap to the next row

`FlowStack` supports vertical and horizontal alignment

Horizontal alignment will align rows

Vertical alignment will align cells based on row height

`FlowStackLayout` conforms to `Layout` protocol, while `FlowStack` conforms to `View` and wraps `FlowStackLayout`

View modifiers can't be used with `Layout` protocol, so `FlowStack` is preferred for normal use

`FlowStack(alignment: Alignment = .center, horizontalSpacing: Double? = nil, verticalSpacing: Double? = nil, content: @escaping () -> Content)`

```swift
FlowStack {
    ForEach(0...20, id: \.self) {
        Text(String($0))
            .foregroundColor(Color(uiColor: .systemBackground))
            .padding([.leading, .trailing])
            .frame(height: 30)
            .background {
                Capsule()
                    .fill(.mint)
            }
    }
}
```

`FlowStackLayout(alignment: Alignment = .center, horizontalSpacing: Double? = nil, verticalSpacing: Double? = nil)`

```swift
let layout = isVertical ? AnyLayout(VStack()) : AnyLayout(FlowStackLayout())

layout {
  
}
```

## Installation

### Swift Package Manager

```swift
https://github.com/smyshlaevalex/FlowStackLayout.git
```
