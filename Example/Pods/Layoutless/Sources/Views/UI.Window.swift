//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 Srdan Rasic (@srdanrasic)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

extension UI {
    
    open class Window: UIWindow {
        
        /// A closure that gets called with `self` as an argument on `layoutSubviews`.
        /// Use it to configure styles that are derived from the view bounds.
        public var onLayout: (Window) -> Void = { _ in }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
            defineLayout()
        }
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
            defineLayout()
        }
        
        open override func layoutSubviews() {
            super.layoutSubviews()
            onLayout(self)
        }
        
        open func setup() {
        }
        
        open func defineLayout() {
            _ = subviewsLayout.layout(in: self)
        }
        
        open var subviewsLayout: AnyLayout {
            return EmptyLayout()
        }
        
        open override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            guard let superview = superview else { return }
            
            if #available(iOS 11.0, *) {
                // safeAreaLayoutGuide is already available
            } else {
                NSLayoutConstraint.activate([
                    ___safeAreaLayoutGuide.topAnchor.constraint(equalTo: superview.___safeAreaLayoutGuide.topAnchor),
                    ___safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: superview.___safeAreaLayoutGuide.bottomAnchor)
                ])
            }
        }
        
        open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            postWindowTraitCollectionDidChangeNotification()
        }
        
        open override var frame: CGRect {
            didSet {
                postWindowTraitCollectionDidChangeNotification()
            }
        }
        
        private var previousWindowTraitCollecton: WindowTraitCollection?
        
        private func postWindowTraitCollectionDidChangeNotification() {
            guard previousWindowTraitCollecton != windowTraitCollection else { return }
            previousWindowTraitCollecton = windowTraitCollection
            NotificationCenter.default.post(name: .windowTraitCollectionDidChange, object: self)
        }
    }
}

extension Notification.Name {

    public static let windowTraitCollectionDidChange = Notification.Name("windowTraitCollectionDidChange")
}
