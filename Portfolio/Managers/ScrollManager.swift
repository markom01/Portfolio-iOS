//
//  ScrollManager.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 10.3.24..
//

import SwiftUI

class ScrollManager {
    class DirectionDetector: NSObject, ObservableObject, UIScrollViewDelegate {
        @Published var isScrolledUp: Bool = true

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            DispatchQueue.main.async { [self] in
                withAnimation(.smooth(duration: 0.6)) {
                    isScrolledUp = scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0
                }
            }
        }
    }

    class Pager: NSObject, UIScrollViewDelegate {
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            let page = round(targetContentOffset.pointee.x / 70)
            targetContentOffset.pointee.x = page * 70
        }
    }
}
