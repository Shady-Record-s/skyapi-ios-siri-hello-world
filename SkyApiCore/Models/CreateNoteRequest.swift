//
//  CreateNoteRequest.swift
//  SkyApiCore
//
//  Created by Christi Schneider on 12/17/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation

class CreateNoteRequest: NSObject, NSCoding, Codable {

    enum CreateNoteRequestCodingKeys: String, CodingKey {
        case constituent_id
        case date
        case summary
        case text
        case type
    }

    var constituent_id: String = ""
    var date: FuzzyDate = FuzzyDate()
    var summary: String = ""
    var text: String = ""
    var type: String = ""

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CreateNoteRequestCodingKeys.self)
        try container.encode(constituent_id, forKey: .constituent_id)
        try container.encode(date, forKey: .date)
        try container.encode(summary, forKey: .summary)
        try container.encode(text, forKey: .text)
        try container.encode(type, forKey: .type)
    }

    func encode(with coder: NSCoder) {
        coder.encode(constituent_id, forKey: "constituent_id")
        coder.encode(date, forKey: "date")
        coder.encode(summary, forKey: "summary")
        coder.encode(text, forKey: "text")
        coder.encode(type, forKey: "type")
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CreateNoteRequestCodingKeys.self)
        constituent_id = (try? container.decode(String.self, forKey: .constituent_id)) ?? ""
        date = (try? container.decode(FuzzyDate.self, forKey: .date)) ?? FuzzyDate()
        summary = (try? container.decode(String.self, forKey: .summary)) ?? ""
        text = (try? container.decode(String.self, forKey: .text)) ?? ""
        type = (try? container.decode(String.self, forKey: .type)) ?? ""
    }

    required init?(coder decoder: NSCoder) {
        constituent_id = decoder.decodeObject(forKey: "constituent_id") as? String ?? ""
        date = decoder.decodeObject(forKey: "date") as? FuzzyDate ?? FuzzyDate()
        summary = decoder.decodeObject(forKey: "summary") as? String ?? ""
        text = decoder.decodeObject(forKey: "text") as? String ?? ""
        type = decoder.decodeObject(forKey: "type") as? String ?? ""
    }

    override init() {
        super.init()
    }
}
