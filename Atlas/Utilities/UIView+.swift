//
//  UIView+.swift
//  Atlas
//
//  Created by Parvin Sital on 13/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

extension UIView {
    func spacer() -> UIView {
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return self
    }
}
