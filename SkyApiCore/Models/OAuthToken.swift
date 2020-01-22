//
//  OAuthToken.swift
//  SkyApiCore
//
//  Created by Christi Schneider on 1/16/20.
//  Copyright © 2020 Blackbaud. All rights reserved.
//

import Foundation

public class OAuthToken: NSObject, NSCoding, Codable {
    
    enum OAuthTokenKeys: String, CodingKey {
        case access_token
        case environment_id
        case environment_name
        case expires_in
        case legal_entity_id
        case legal_entity_name
        case refresh_token
        case refresh_token_expires_in
        case token_type
        case user_id
    }

    public var access_token: String = ""
    public var environment_id: String = ""
    public var environment_name: String = ""
    public var expires_in: Int = 0
    public var legal_entity_id: String = ""
    public var legal_entity_name: String = ""
    public var refresh_token: String = ""
    public var refresh_token_expires_in: Int = 0
    public var token_type: String = ""
    public var user_id: String = ""

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: OAuthTokenKeys.self)
        try container.encode(access_token, forKey: .access_token)
        try container.encode(environment_id, forKey: .environment_id)
        try container.encode(environment_name, forKey: .environment_name)
        try container.encode(expires_in, forKey: .expires_in)
        try container.encode(legal_entity_id, forKey: .legal_entity_id)
        try container.encode(legal_entity_name, forKey: .legal_entity_name)
        try container.encode(refresh_token, forKey: .refresh_token)
        try container.encode(refresh_token_expires_in, forKey: .refresh_token_expires_in)
        try container.encode(token_type, forKey: .token_type)
        try container.encode(user_id, forKey: .user_id)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(environment_id, forKey: "environment_id")
        aCoder.encode(environment_name, forKey: "environment_name")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(legal_entity_id, forKey: "legal_entity_id")
        aCoder.encode(legal_entity_name, forKey: "legal_entity_name")
        aCoder.encode(refresh_token, forKey: "refresh_token")
        aCoder.encode(refresh_token_expires_in, forKey: "refresh_token_expires_in")
        aCoder.encode(token_type, forKey: "token_type")
        aCoder.encode(user_id, forKey: "user_id")
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OAuthTokenKeys.self)
        access_token = (try? container.decode(String.self, forKey: .access_token)) ?? ""
        environment_id = (try? container.decode(String.self, forKey: .environment_id)) ?? ""
        environment_name = (try? container.decode(String.self, forKey: .environment_name)) ?? ""
        expires_in = (try? container.decode(Int.self, forKey: .expires_in)) ?? 0
        legal_entity_id = (try? container.decode(String.self, forKey: .legal_entity_id)) ?? ""
        legal_entity_name = (try? container.decode(String.self, forKey: .legal_entity_name)) ?? ""
        refresh_token = (try? container.decode(String.self, forKey: .refresh_token)) ?? ""
        refresh_token_expires_in = (try? container.decode(Int.self, forKey: .refresh_token_expires_in)) ?? 0
        token_type = (try? container.decode(String.self, forKey: .token_type)) ?? ""
        user_id = (try? container.decode(String.self, forKey: .user_id)) ?? ""
    }

    public required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String ?? ""
        environment_id = aDecoder.decodeObject(forKey: "environment_id") as? String ?? ""
        environment_name = aDecoder.decodeObject(forKey: "environment_name") as? String ?? ""
        expires_in = aDecoder.decodeObject(forKey: "expires_in") as? Int ?? 0
        legal_entity_id = aDecoder.decodeObject(forKey: "legal_entity_id") as? String ?? ""
        legal_entity_name = aDecoder.decodeObject(forKey: "legal_entity_name") as? String ?? ""
        refresh_token = aDecoder.decodeObject(forKey: "refresh_token") as? String ?? ""
        refresh_token_expires_in = aDecoder.decodeObject(forKey: "refresh_token_expires_in") as? Int ?? 0
        token_type = aDecoder.decodeObject(forKey: "token_type") as? String ?? ""
        user_id = aDecoder.decodeObject(forKey: "user_id") as? String ?? ""
    }

    override init() {
        super.init()
    }
}
