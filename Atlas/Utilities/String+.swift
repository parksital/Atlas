//
//  String+.swift
//  Atlas
//
//  Created by Parvin Sital on 08/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

extension String {
    func decodeFromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func encodeToBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
