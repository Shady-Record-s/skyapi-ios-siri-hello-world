//
//  SkyApiError.swift
//  SkyApiCore
//
//  Created by Christi Schneider on 12/30/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation

public class SkyApiError : Error {
    public var data: Data?
    
    public init(data: Data?) {
        self.data = data
    }
}
