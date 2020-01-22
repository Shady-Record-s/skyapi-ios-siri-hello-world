//
//  Constituent.swift
//  Person
//
//  Created by Christi Schneider on 11/19/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation

public class Constituent: NSObject, NSCoding, Codable {

    enum ConstituentCodingKeys: String, CodingKey {
        case id
        case email
        case first
        case last
        case full_name
        case initials
    }

    public var id: String = ""
    public var email: String = ""
    public var first: String = ""
    public var last: String = ""
    public var full_name: String = ""
    public var initials: String = ""

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ConstituentCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(first, forKey: .first)
        try container.encode(last, forKey: .last)
        try container.encode(full_name, forKey: .full_name)
        try container.encode(initials, forKey: .initials)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(first, forKey: "first")
        aCoder.encode(last, forKey: "last")
        aCoder.encode(full_name, forKey: "full_name")
        aCoder.encode(initials, forKey: "initials")
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ConstituentCodingKeys.self)

        id = (try? container.decode(String.self, forKey: .id)) ?? ""
        email = (try? container.decode(String.self, forKey: .email)) ?? ""
        first = (try? container.decode(String.self, forKey: .first)) ?? ""
        last = (try? container.decode(String.self, forKey: .last)) ?? ""
        full_name = (try? container.decode(String.self, forKey: .full_name)) ?? ""
        initials = (try? container.decode(String.self, forKey: .initials)) ?? ""
    }

    public required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        first = aDecoder.decodeObject(forKey: "first") as? String ?? ""
        last = aDecoder.decodeObject(forKey: "last") as? String ?? ""
        full_name = aDecoder.decodeObject(forKey: "full_name") as? String ?? ""
        initials = aDecoder.decodeObject(forKey: "initials") as? String ?? ""
    }

    override init() {
        super.init()
    }
}
