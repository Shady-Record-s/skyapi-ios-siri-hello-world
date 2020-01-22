//
//  CreateActionRequest.swift
//  SkyApiCore
//
//  Created by Christi Schneider on 12/23/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation

class CreateActionRequest: NSObject, NSCoding, Codable {

    enum CreateActionRequestCodingKeys: String, CodingKey {
        case category
        case constituent_id
        case date
        case summary
        case description
        case type
    }

    var category: String = ""
    var constituent_id: String = ""
    /** Required */
    var date: Date?
    var summary: String = ""
    var actionDescription: String = ""
    var type: String = ""

    let dateFormatter = DateFormatter()

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CreateActionRequestCodingKeys.self)
        try container.encode(category, forKey: .category)
        try container.encode(constituent_id, forKey: .constituent_id)
        if let date = date {
            let dateStr = dateFormatter.string(from: date)
            try container.encode(dateStr, forKey: .date)
        }
        try container.encode(summary, forKey: .summary)
        try container.encode(actionDescription, forKey: .description)
        try container.encode(type, forKey: .type)
    }

    func encode(with coder: NSCoder) {
        coder.encode(category, forKey: "category")
        coder.encode(constituent_id, forKey: "constituent_id")
        if let date = date {
            let dateStr = dateFormatter.string(from: date)
            coder.encode(dateStr, forKey: "date")
        }
        coder.encode(summary, forKey: "summary")
        coder.encode(actionDescription, forKey: "description")
        coder.encode(type, forKey: "type")
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CreateActionRequestCodingKeys.self)

        category = (try? container.decode(String.self, forKey: .category)) ?? ""
        constituent_id = (try? container.decode(String.self, forKey: .constituent_id)) ?? ""
        if let dateStr = try? container.decode(String?.self, forKey: .date) {
            date = dateFormatter.date(from: dateStr)
        }
        summary = (try? container.decode(String.self, forKey: .summary)) ?? ""
        actionDescription = (try? container.decode(String.self, forKey: .description)) ?? ""
        type = (try? container.decode(String.self, forKey: .type)) ?? ""
    }

    required init?(coder decoder: NSCoder) {
        category = decoder.decodeObject(forKey: "category") as? String ?? ""
        constituent_id = decoder.decodeObject(forKey: "constituent_id") as? String ?? ""
        if let dateStr = decoder.decodeObject(forKey: "date") as? String {
            date = dateFormatter.date(from: dateStr)
        }
        summary = decoder.decodeObject(forKey: "summary") as? String ?? ""
        actionDescription = decoder.decodeObject(forKey: "description") as? String ?? ""
        type = decoder.decodeObject(forKey: "type") as? String ?? ""
    }

    override init() {
        super.init()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
}
