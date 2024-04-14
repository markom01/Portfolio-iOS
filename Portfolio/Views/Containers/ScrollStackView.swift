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
    var selectedId: UUID?
#if os(iOS)
    var delegate: UIScrollViewDelegate?
#endif
    @ViewBuilder let content: T

    var body: some View {
        let layout: AnyLayout = axis == .horizontal
        ? .init(HStackLayout(spacing: spacing))
        : .init(VStackLayout(spacing: spacing))

        ScrollViewReader { proxy in
            ScrollView(axis) {
                layout {
                    content
                    if axis == .vertical {
                        Spacer().frame(height: .small)
                    }
                }
            }
#if os(iOS)
            .introspect(.scrollView, on: .iOS(.v17)) {
                $0.delegate = delegate
                $0.bounces = false
            }
#endif
            .scrollIndicators(.hidden)
            .onChange(of: selectedId) {
                withAnimation {
                    proxy.scrollTo(selectedId, anchor: .top)
                }
            }
        }
    }
}

struct ScrollStackDemo: View {
    @State var selectedId: UUID?
    let data: [IdentifiableData] = Array(1...30).map { .init(entry: "\($0)") }

    var body: some View {
        ScrollStackView(axis: .vertical, selectedId: selectedId) {
            ForEach(data) { dataEntry in
                Text(dataEntry.entry)
                    .id(dataEntry.id)
                    .onTapGesture {
                        selectedId = dataEntry.id
                    }
            }
        }
    }
}

#Preview {
    ScrollStackDemo()
}
