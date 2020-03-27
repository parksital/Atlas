//
//  Fetchable.swift
//  Atlas
//
//  Created by Parvin Sital on 26/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AWSAppSync

protocol Fetchable {
    associatedtype Q: GraphQLQuery
    var query: Q { get }
}
