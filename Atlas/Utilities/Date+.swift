//
//  Date+.swift
//  Atlas
//
//  Created by Parvin Sital on 16/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

extension Date {
    func formatted(using formatting: (Date) -> String) -> String {
        return formatting(self)
    }
}
