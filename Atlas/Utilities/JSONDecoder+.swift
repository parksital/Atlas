//
//  JSONDecoder+.swift
//  Atlas
//
//  Created by Parvin Sital on 27/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyedBy key: String?) throws -> [T] {
        guard let key = key else { throw NetworkError.generic }
        userInfo[.rootKeyName] = key
        let root = try decode(ListContainer<T>.self, from: data)
        return root.values
    }
}
