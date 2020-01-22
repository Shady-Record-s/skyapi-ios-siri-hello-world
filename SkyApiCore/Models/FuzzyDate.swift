//
//  FuzzyDate.swift
//  SkyApiCore
//
//  Created by Christi Schneider on 12/17/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation

class FuzzyDate: NSObject, NSCoding, Codable {

    enum FuzzyDateCodingKeys: String, CodingKey {
        case d
        case m
        case y
    }

    var d: String = ""
    var m: String = ""
    var y: String = ""

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: FuzzyDateCodingKeys.self)
        try container.encode(d, forKey: .d)
        try container.encode(m, forKey: .m)
        try container.encode(y, forKey: .y)
    }

    func encode(with coder: NSCoder) {
        coder.encode(d, forKey: "d")
        coder.encode(m, forKey: "m")
        coder.encode(y, forKey: "y")
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FuzzyDateCodingKeys.self)
        d = (try? container.decode(String.self, forKey: .d)) ?? ""
        m = (try? container.decode(String.self, forKey: .m)) ?? ""
        y = (try? container.decode(String.self, forKey: .y)) ?? ""
    }

    required init?(coder decoder: NSCoder) {
        d = decoder.decodeObject(forKey: "d") as? String ?? ""
        m = decoder.decodeObject(forKey: "m") as? String ?? ""
        y = decoder.decodeObject(forKey: "y") as? String ?? ""
    }

    override init() {
        super.init()
    }

    init(from date: Date) {
        let calenderDate = Calendar.current.dateComponents([.day, .year, .month], from: Date())
        d = String(format: "%02d", calenderDate.day!)
        m = String(format: "%02d", calenderDate.month!)
        y = String(format: "%04d", calenderDate.year!)
    }
}
