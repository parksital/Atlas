//
//  Styling.swift
//  Atlas
//
//  Created by Parvin Sital on 20/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

enum Styling {
    case title
    case primary
    case secondary
    case headline
    case body
}

extension Styling {
    var font: UIFont {
        switch self {
        case .title: return .preferredFont(for: .title1, weight: .regular)
        case .primary: return .preferredFont(for: .headline, weight: .bold)
        case .secondary: return .preferredFont(for: .headline, weight: .regular)
        case .headline: return .preferredFont(for: .headline, weight: .regular)
        case .body: return .preferredFont(for: .body, weight: .regular)
        }
    }
    
    var fontColor: UIColor {
        return .label
    }
}
