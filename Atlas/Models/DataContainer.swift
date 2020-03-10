//
//  DataContainer.swift
//  Atlas
//
//  Created by Parvin Sital on 04/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

struct DataContainer<T: Decodable>: Decodable {
    let data: T
}
