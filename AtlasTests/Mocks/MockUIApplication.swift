//
//  MockUIApplication.swift
//  Atlas
//
//  Created by Parvin Sital on 10/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

class MockUIApplication: URLOpening {
    var openURLCalledCount: Int = 0
    var authorizedLinks: [URL]
    
    init(authorizedLinks: [URL]) {
        self.authorizedLinks = authorizedLinks
    }
    
    func canOpenURL(_ url: URL) -> Bool {
        return authorizedLinks.contains(url)
    }
    
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
        openURLCalledCount += 1
    }
}
