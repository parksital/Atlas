//
//  URLOpening.swift
//  Atlas
//
//  Created by Parvin Sital on 10/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

protocol URLOpening {
    func canOpenURL(_ url: URL) -> Bool
    func open(
        _ url: URL,
        completion: (() -> Void)?
    )
    func open(
        _ url: URL,
        options: [String: Any],
        completion: (() -> Void)?
    )
}

extension UIApplication: URLOpening {
    func open(
        _ url: URL,
        completion: (() -> Void)?
    ) {
        self.open(url, options: [:], completion: completion)
    }
    
    func open(
        _ url: URL,
        options: [String: Any],
        completion: (() -> Void)?
    ) {
        self.open(url, options: [:], completionHandler: nil)
    }
}
