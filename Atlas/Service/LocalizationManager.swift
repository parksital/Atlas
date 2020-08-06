//
//  LocalizationManager.swift
//  Atlas
//
//  Created by Parvin Sital on 05/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

typealias L = LocalizationManager
final class LocalizationManager {
    private let locale: Locale!
    
    private var currentLanguage: LanguageCode {
        return locale.languageCode
            .flatMap(LanguageCode.init) ?? .english
    }
    
    init(locale: Locale = .current) {
        self.locale = locale
    }
    
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
