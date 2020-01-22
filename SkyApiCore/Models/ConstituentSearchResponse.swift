//
//  ConstituentSearchResponse.swift
//  SkyApiCore
//
//  Created by Christi Schneider on 11/22/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation

class ConstituentSearchResponse: NSObject, NSCoding, Codable {

    enum ConstituentSearchResponseCodingKeys: String, CodingKey {
        case count
        case next_link
        case value
    }

    public var count: Int = 0
    public var next_link: String? = nil
    public var value: [ConstituentSearchResult] = []

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ConstituentSearchResponseCodingKeys.self)
        try container.encode(count, forKey: .count)
        try container.encode(next_link, forKey: .next_link)
        try container.encode(value, forKey: .value)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(count, forKey: "count")
        aCoder.encode(next_link, forKey: "next_link")
        aCoder.encode(value, forKey: "value")
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ConstituentSearchResponseCodingKeys.self)

        count = (try? container.decode(Int.self, forKey: .count)) ?? 0
        next_link = try? container.decode(String.self, forKey: .next_link)
        value = (try? container.decode([ConstituentSearchResult].self, forKey: .value)) ?? []
    }

    public required init?(coder aDecoder: NSCoder) {
        count = aDecoder.decodeObject(forKey: "count") as? Int ?? 0
        next_link = aDecoder.decodeObject(forKey: "next_link") as? String ?? nil
        value = aDecoder.decodeObject(forKey: "value") as? [ConstituentSearchResult] ?? []
    }

    override init() {
        super.init()
    }
}
