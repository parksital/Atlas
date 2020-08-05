//
//  LocalizationManager.swift
//  Atlas
//
//  Created by Parvin Sital on 05/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

enum LanguageCode: String {
    case english = "en"
    case dutch = "nl"

    static var systemLanguageCode: LanguageCode? {
        return Locale.current.languageCode.flatMap(LanguageCode.init)
    }

    var languageName: String {
        switch self {
        case .english:
            return "English"
        case .dutch:
            return "Dutch"
        }
    }
}

final class LocalizationManager {
    var currentLanguage: LanguageCode = .systemLanguageCode ?? .english
    
    func localize(
        _ key: String,
        tableName: String? = nil
    ) -> String {
        guard
            let path = Bundle(for: LocalizationManager.self)
                .path(forResource: currentLanguage.rawValue, ofType: "lproj"),
            let bundle = Bundle(path: path)
            else { return key }
        
        return NSLocalizedString(
            key,
            tableName: tableName,
            bundle: bundle,
            comment: "")
    }
}
