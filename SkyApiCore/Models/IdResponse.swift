//
//  IdResponse.swift
//  SkyApiCore
//
//  Created by Christi Schneider on 12/17/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation

class IdResponse: NSObject, NSCoding, Codable {

    enum IdResponseCodingKeys: String, CodingKey {
        case id
    }

    var id: String = ""

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: IdResponseCodingKeys.self)
        try container.encode(id, forKey: .id)
    }

    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: IdResponseCodingKeys.self)
        id = (try? container.decode(String.self, forKey: .id)) ?? ""
    }

    required init?(coder decoder: NSCoder) {
        id = decoder.decodeObject(forKey: "id") as? String ?? ""
    }

    override init() {
        super.init()
    }
}
