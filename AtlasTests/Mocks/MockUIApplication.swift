//
//  MockUIApplication.swift
//  Atlas
//
//  Created by Parvin Sital on 10/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

struct MockUIApplication: URLOpening {
    var authorizedLinks: [URL]
    func canOpenURL(_ url: URL) -> Bool {
        return authorizedLinks.contains(url)
    }
}
