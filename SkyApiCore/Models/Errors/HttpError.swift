//
//  HttpError.swift
//  SkyApiCore
//
//  Created by Christi Schneider on 12/30/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation

public class HttpError : Error {
    public var statusCode: Int
    public var data: Data?
    public var error: Error?

    public var dataAsString: String? {
        guard let data = data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    public init(statusCode: Int, data: Data?, error: Error?) {
        self.statusCode = statusCode
        self.data = data
        self.error = error
    }
}
