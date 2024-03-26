//
//  ScrollStackView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 13.3.24..
//

import SwiftUI

struct ScrollStackView<T: View>: View {
    var axis: Axis.Set = .vertical
    var spacing: CGFloat = .medium
#if os(iOS)
    var delegate: UIScrollViewDelegate?
#endif
    @ViewBuilder let content: T

    var body: some View {
        let layout: AnyLayout = axis == .horizontal
        ? .init(HStackLayout(spacing: spacing))
        : .init(VStackLayout(spacing: spacing))

        ScrollView(axis) {
            layout {
                content
            }
        }
#if os(iOS)
        .introspect(.scrollView, on: .iOS(.v17)) {
            $0.delegate = delegate
            $0.bounces = false
        }
#endif
        .scrollIndicators(.hidden)
    }
}

extension ScrollStackView {
    struct IdentifiableData: Identifiable {
        let entry: Any
        let id = UUID()
    }
}

#Preview {
    ScrollStackView(axis: .horizontal) {
        ForEach(1...10, id: \.self) {
            Text("\($0)")
        }
    }
}
