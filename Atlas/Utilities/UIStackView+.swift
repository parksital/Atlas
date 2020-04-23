//
//  UIStackView+.swift
//  Atlas
//
//  Created by Parvin Sital on 24/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

extension UIStackView {
    func addSpacer() {
        self.arrangedSubviews.forEach {
            $0.setContentHuggingPriority(.defaultHigh, for: self.axis)
        }
        self.addArrangedSubview({
            let view = UIView()
            view.setContentHuggingPriority(.defaultLow, for: self.axis)
            view.setContentCompressionResistancePriority(.defaultLow, for: self.axis)
            return view
            }())
    }
    
    func populateWithViews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
