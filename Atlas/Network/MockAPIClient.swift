//
//  MockAPIClient.swift
//  Atlas
//
//  Created by Parvin Sital on 04/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

final class MockAPIClient: APIClientProtocol {
    private (set) var decoder: JSONDecoder! = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func request<D: Decodable>(data: D.Type, _ completion: @escaping (Result<D, Error>) -> Void) {
        let json = stubbedResponse("Events")
        
        do {
            let data = try decoder.decode(DataContainer<D>.self, from: json)
            completion(.success(data.data))
        } catch {
            completion(.failure(error))
        }
    }
}

private extension MockAPIClient {
    private func stubbedResponse(_ filename: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Missing file: \(filename).json")
        }
        
        return try! Data(contentsOf: url)
    }
}
