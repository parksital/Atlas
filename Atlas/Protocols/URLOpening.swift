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
}

extension UIApplication: URLOpening { }
