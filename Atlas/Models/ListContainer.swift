//
//  ListContainer.swift
//  Atlas
//
//  Created by Parvin Sital on 27/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

struct ListContainer<T: Decodable> {
    let values: [T]
}

extension ListContainer: Decodable {
    private struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = "\(intValue)"
        }
        
        static func key(named name: String) -> CodingKeys? {
            return CodingKeys(stringValue: name)
        }
    }
    
    enum RootKeys: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        guard
            let keyName = decoder.userInfo[.rootKeyName] as? String,
            let key = CodingKeys.key(named: keyName)
            else {
                assertionFailure("key not found")
                throw NetworkError.generic
        }
        
        let data = try decoder.container(keyedBy: CodingKeys.self)
        let type = try data.nestedContainer(keyedBy: RootKeys.self, forKey: key)
        var unkeyedItems = try type.nestedUnkeyedContainer(forKey: .items)
        
        var output: [T] = []
        while !unkeyedItems.isAtEnd {
            let element = try unkeyedItems.decode(T.self)
            output.append(element)
        }
        self.values = output
    }
}
