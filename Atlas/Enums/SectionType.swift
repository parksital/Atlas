//
//  SectionType.swift
//  Atlas
//
//  Created by Parvin Sital on 19/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

enum SectionType: CaseIterable {
    typealias AllCases = [SectionType]
    static var allCases: [SectionType] {
        return [.tonight, .tomorrow, .date("")]
    }
    
    case tonight
    case tomorrow
    case date(String?)
    
    var header: String? {
        switch self {
        case .tonight: return "Tonight"
        case .tomorrow: return "Tomorrow"
        case .date(let custom):
            guard
                let date = custom,
                !date.isEmpty else { return nil }
            return date
            
        }
    }
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .tonight
        case 1: self = .tomorrow
        default: return nil
        }
    }
}

extension SectionType: Equatable { }
