//
//  EventSummary.swift
//  Atlas
//
//  Created by Parvin Sital on 04/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

struct EventSummary {
    let id: String
    let title: String
    let startDate: Date
    let venue: String
}

extension EventSummary: Equatable { }
