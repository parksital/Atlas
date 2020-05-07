//
//  UILabel+.swift
//  Atlas
//
//  Created by Parvin Sital on 20/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(styling: Styling) {
        self.init()
        self.font = styling.font
        self.textColor = styling.fontColor
        self.textAlignment = .natural
        self.numberOfLines = 0
    }
    
    func applyStyling(_ styling: Styling) {
        self.font = styling.font
        self.textColor = styling.fontColor
        self.textAlignment = .natural
        self.numberOfLines = 0
    }
}
