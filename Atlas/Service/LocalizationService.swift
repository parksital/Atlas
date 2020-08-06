//
//  LocalizationService.swift
//  Atlas
//
//  Created by Parvin Sital on 05/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol HasLocalization: class {
    var tableName: String { get }
    var localizationManager: LocalizationService { get }
}

final class LocalizationService {
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
            let path = Bundle(for: LocalizationService.self)
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

extension VIPViewControllerProtocol where Self: HasLocalization {
    /// Every (UI)ViewController that conforms VIPViewControllerProtocol
    /// and HasLocalization will have access to this method
    func localize(_ key: String) -> String {
        localizationManager.localize(key, tableName: tableName)
    }
}
