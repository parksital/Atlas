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
    case headline
    case body
}

extension Styling {
    var font: UIFont {
        switch self {
        case .title: return .preferredFont(forTextStyle: .title1)
        case .headline: return .preferredFont(forTextStyle: .headline)
        case .body: return .preferredFont(forTextStyle: .body)
        }
    }
    
    var fontColor: UIColor {
        switch self {
        case .title: return .black
        case .headline: return .black
        case .body: return .black
        }
    }
}
