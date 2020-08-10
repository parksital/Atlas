//
//  ServiceInjection.swift
//  Atlas
//
//  Created by Parvin Sital on 06/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Swinject

protocol ServiceInjection { }
extension ServiceInjection {
    func resolveLocalization<C: UIViewController>(
        _ r: Resolver,
        _ vc: C) where C: HasLocalization {
        vc.localizationService = r.resolve(LocalizationService.self)!
    }
}
