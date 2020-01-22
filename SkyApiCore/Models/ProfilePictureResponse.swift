//
//  ProfilePictureResponse.swift
//  SkyApiCore
//
//  Created by Christi Schneider on 12/13/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation

class ProfilePictureResponse: NSObject, NSCoding, Codable {

    enum ProfilePictureResponseCodingKeys: String, CodingKey {
        case constituent_id
        case thumbnail_url
        case url
    }

    public var constituent_id: String = ""
    public var thumbnail_url: String = ""
    public var url: String = ""
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ProfilePictureResponseCodingKeys.self)
        try container.encode(constituent_id, forKey: .constituent_id)
        try container.encode(thumbnail_url, forKey: .thumbnail_url)
        try container.encode(url, forKey: .url)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(constituent_id, forKey: "constituent_id")
        aCoder.encode(thumbnail_url, forKey: "thumbnail_url")
        aCoder.encode(url, forKey: "url")
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProfilePictureResponseCodingKeys.self)
        constituent_id = (try? container.decode(String.self, forKey: .constituent_id)) ?? ""
        thumbnail_url = (try? container.decode(String.self, forKey: .thumbnail_url)) ?? ""
        url = (try? container.decode(String.self, forKey: .url)) ?? ""
    }

    public required init?(coder aDecoder: NSCoder) {
        constituent_id = aDecoder.decodeObject(forKey: "constituent_id") as? String ?? ""
        thumbnail_url = aDecoder.decodeObject(forKey: "thumbnail_url") as? String ?? ""
        url = aDecoder.decodeObject(forKey: "url") as? String ?? ""
    }

    override init() {
        super.init()
    }
}
