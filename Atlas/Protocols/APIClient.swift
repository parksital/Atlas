//
//  APIClient.swift
//  Atlas
//
//  Created by Parvin Sital on 27/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol APIClient {
    func fetch<R: Fetchable & Mockable>(
        request: R,
        _ completion: @escaping (Result<Data, Error>) -> Void
    )
}
