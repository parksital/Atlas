//
//  MockAPIClient.swift
//  Atlas
//
//  Created by Parvin Sital on 25/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AWSAppSync

final class MockAPIClient {
    static func getDataFromFile(fileName: String, extension: String) -> Data {
        let bundle = Bundle(for: MockAPIClient.self)
        let path = bundle.path(forResource: fileName, ofType: `extension`)
        let url = URL(fileURLWithPath: path!)
        return try! Data(contentsOf: url)
    }
    
    func getMock(mockable: Mockable) -> Data {
        let bundle = Bundle(for: MockAPIClient.self)
        let path = bundle.path(forResource: mockable.fileName!, ofType: mockable.extension)
        let url = URL(fileURLWithPath: path!)
        return try! Data(contentsOf: url)
    }
}

extension MockAPIClient: AWSAppSyncClientProtocol {
    func request<F: Fetchable & Mockable>(
        query: F,
        completion: ((Data?, Error?) -> Void)?) {
        let data = getMock(mockable: query)
        completion?(data, nil)
    }
}
