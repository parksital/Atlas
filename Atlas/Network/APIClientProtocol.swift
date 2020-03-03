//
//  APIClientProtocol.swift
//  Atlas
//
//  Created by Parvin Sital on 03/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol APIClientProtocol: class {
    var initialized: Bool { get set }
    func fetch()
}
