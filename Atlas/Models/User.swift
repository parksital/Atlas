//
//  User.swift
//  Atlas
//
//  Created by Parvin Sital on 01/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

struct GetUser: Decodable {
    let user: User
    enum CodingKeys: String, CodingKey {
        case user = "getUser"
    }
}

struct User {
    let id: String
    let firstName: String
    let familyName: String
    let points: Int
}

extension User: Decodable { }
extension User: Hashable { }

enum Account {
    struct Request: Fetchable, Mockable {
        var fileName: String? { return "userByID" }
        var `extension`: String { return "json" }
        
        private var id: String
        var query: GetUserQuery { .init(id: id) }
        
        init(id: String) {
            self.id = id
        }
    }
}
