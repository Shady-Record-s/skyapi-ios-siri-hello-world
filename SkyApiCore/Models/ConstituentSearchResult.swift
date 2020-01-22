//
//  ConstituentSearchResult.swift
//  SkyApiCore
//
//  Created by Christi Schneider on 11/22/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation

public class ConstituentSearchResult: NSObject, NSCoding, Codable {

    enum ConstituentSearchResultCodingKeys: String, CodingKey {
        case id
        case address
        case deceased
        case email
        case fundraiser_status
        case inactive
        case lookup_id
        case name
    }

    public var id: String = ""
    public var address: String = ""
    public var deceased: Bool = false
    public var email: String = ""
    public var fundraiser_status: String = ""
    public var inactive: Bool = false
    public var lookup_id: String = ""
    public var name: String = ""

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ConstituentSearchResultCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(address, forKey: .address)
        try container.encode(deceased, forKey: .deceased)
        try container.encode(email, forKey: .email)
        try container.encode(fundraiser_status, forKey: .fundraiser_status)
        try container.encode(inactive, forKey: .inactive)
        try container.encode(lookup_id, forKey: .lookup_id)
        try container.encode(name, forKey: .name)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(deceased, forKey: "deceased")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(fundraiser_status, forKey: "fundraiser_status")
        aCoder.encode(inactive, forKey: "inactive")
        aCoder.encode(lookup_id, forKey: "lookup_id")
        aCoder.encode(name, forKey: "name")
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ConstituentSearchResultCodingKeys.self)
        id = (try? container.decode(String.self, forKey: .id)) ?? ""
        address = (try? container.decode(String.self, forKey: .address)) ?? ""
        deceased = (try? container.decode(Bool.self, forKey: .deceased)) ?? false
        email = (try? container.decode(String.self, forKey: .email)) ?? ""
        fundraiser_status = (try? container.decode(String.self, forKey: .fundraiser_status)) ?? ""
        inactive = (try? container.decode(Bool.self, forKey: .inactive)) ?? false
        lookup_id = (try? container.decode(String.self, forKey: .lookup_id)) ?? ""
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
    }

    public required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        address = aDecoder.decodeObject(forKey: "address") as? String ?? ""
        deceased = aDecoder.decodeObject(forKey: "deceased") as? Bool ?? false
        email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        fundraiser_status = aDecoder.decodeObject(forKey: "fundraiser_status") as? String ?? ""
        inactive = aDecoder.decodeObject(forKey: "inactive") as? Bool ?? false
        lookup_id = aDecoder.decodeObject(forKey: "lookup_id") as? String ?? ""
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
    }

    override init() {
        super.init()
    }
}
