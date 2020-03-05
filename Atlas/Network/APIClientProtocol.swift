//
//  APIClientProtocol.swift
//  Atlas
//
//  Created by Parvin Sital on 03/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol APIClientProtocol: class {
    var decoder: JSONDecoder! { get }
    func request<D: Decodable>(data: D.Type, _ completion: @escaping (Result<D, Error>) -> Void)
}
