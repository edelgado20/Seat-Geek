//
//  Events.swift
//  SeatGeek
//
//  Created by Edgar Delgado on 1/21/21.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let events = try? newJSONDecoder().decode(Events.self, from: jsonData)

import Foundation

// MARK: - Events
struct Events: Codable {
    let events: [Event]
    let meta: Meta
    let inHand: InHand

    enum CodingKeys: String, CodingKey {
        case events, meta
        case inHand = "in_hand"
    }
}

// MARK: - Event
struct Event: Codable {
    let type: TypeEnum
    let id: Int
    let datetimeUTC: String
    let venue: Venue
    let datetimeTbd: Bool
    let performers: [Performer]
    let isOpen: Bool
    let links: [JSONAny]
    let datetimeLocal: String
    let timeTbd: Bool
    let shortTitle, visibleUntilUTC: String
    let stats: EventStats
    let taxonomies: [Taxonomy]
    let url: String
    let score: Double
    let announceDate, createdAt: String
    let dateTbd: Bool
    let title: String
    let popularity: Double
    let eventDescription: String
    let status: Status
    let accessMethod: AccessMethod?
    let eventPromotion: JSONNull?
    let announcements: InHand
    let conditional: Bool
    let enddatetimeUTC: JSONNull?
    let themes, domainInformation: [JSONAny]
    let generalAdmission: Bool?

    enum CodingKeys: String, CodingKey {
        case type, id
        case datetimeUTC = "datetime_utc"
        case venue
        case datetimeTbd = "datetime_tbd"
        case performers
        case isOpen = "is_open"
        case links
        case datetimeLocal = "datetime_local"
        case timeTbd = "time_tbd"
        case shortTitle = "short_title"
        case visibleUntilUTC = "visible_until_utc"
        case stats, taxonomies, url, score
        case announceDate = "announce_date"
        case createdAt = "created_at"
        case dateTbd = "date_tbd"
        case title, popularity
        case eventDescription = "description"
        case status
        case accessMethod = "access_method"
        case eventPromotion = "event_promotion"
        case announcements, conditional
        case enddatetimeUTC = "enddatetime_utc"
        case themes
        case domainInformation = "domain_information"
        case generalAdmission = "general_admission"
    }
}

// MARK: - AccessMethod
struct AccessMethod: Codable {
    let method: String
    let createdAt: Date
    let employeeOnly: Bool

    enum CodingKeys: String, CodingKey {
        case method
        case createdAt = "created_at"
        case employeeOnly = "employee_only"
    }
}

// MARK: - InHand
struct InHand: Codable {
}

// MARK: - Performer
struct Performer: Codable {
    let type, name: String
    let image: String
    let id: Int
    let images: Images
    let divisions: [Division]?
    let hasUpcomingEvents: Bool
    let primary: Bool?
    let stats: PerformerStats
    let taxonomies: [Taxonomy]
    let imageAttribution: String?
    let url: String
    let score: Double
    let slug: String
    let homeVenueID: Int?
    let shortName: String
    let numUpcomingEvents: Int
    let colors: JSONNull?
    let imageLicense: String?
    let popularity: Int
    let homeTeam: Bool?
    let location: Location?
    let awayTeam: Bool?

    enum CodingKeys: String, CodingKey {
        case type, name, image, id, images, divisions
        case hasUpcomingEvents = "has_upcoming_events"
        case primary, stats, taxonomies
        case imageAttribution = "image_attribution"
        case url, score, slug
        case homeVenueID = "home_venue_id"
        case shortName = "short_name"
        case numUpcomingEvents = "num_upcoming_events"
        case colors
        case imageLicense = "image_license"
        case popularity
        case homeTeam = "home_team"
        case location
        case awayTeam = "away_team"
    }
}

// MARK: - Division
struct Division: Codable {
    let taxonomyID: Int
    let shortName: String?
    let displayName: String
    let displayType: DisplayType
    let divisionLevel: Int
    let slug: String?

    enum CodingKeys: String, CodingKey {
        case taxonomyID = "taxonomy_id"
        case shortName = "short_name"
        case displayName = "display_name"
        case displayType = "display_type"
        case divisionLevel = "division_level"
        case slug
    }
}

enum DisplayType: String, Codable {
    case conference = "Conference"
    case division = "Division"
}

// MARK: - Images
struct Images: Codable {
    let huge: String
}

// MARK: - Location
struct Location: Codable {
    let lat, lon: Double
}

// MARK: - PerformerStats
struct PerformerStats: Codable {
    let eventCount: Int

    enum CodingKeys: String, CodingKey {
        case eventCount = "event_count"
    }
}

// MARK: - Taxonomy
struct Taxonomy: Codable {
    let id: Int
    let name: TypeEnum
    let parentID: Int?
    let documentSource: DocumentSource?
    let rank: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case parentID = "parent_id"
        case documentSource = "document_source"
        case rank
    }
}

// MARK: - DocumentSource
struct DocumentSource: Codable {
    let sourceType: SourceType
    let generationType: GenerationType

    enum CodingKeys: String, CodingKey {
        case sourceType = "source_type"
        case generationType = "generation_type"
    }
}

enum GenerationType: String, Codable {
    case full = "FULL"
}

enum SourceType: String, Codable {
    case elastic = "ELASTIC"
}

enum TypeEnum: String, Codable {
    case basketball = "basketball"
    case comedy = "comedy"
    case family = "family"
    case mls = "mls"
    case ncaaWomensBasketball = "ncaa_womens_basketball"
    case soccer = "soccer"
    case sports = "sports"
    case theater = "theater"
}

// MARK: - EventStats
struct EventStats: Codable {
    let listingCount, averagePrice, lowestPriceGoodDeals, lowestPrice: Int?
    let highestPrice, visibleListingCount: Int?
    let dqBucketCounts: [Int]?
    let medianPrice, lowestSgBasePrice, lowestSgBasePriceGoodDeals: Int?

    enum CodingKeys: String, CodingKey {
        case listingCount = "listing_count"
        case averagePrice = "average_price"
        case lowestPriceGoodDeals = "lowest_price_good_deals"
        case lowestPrice = "lowest_price"
        case highestPrice = "highest_price"
        case visibleListingCount = "visible_listing_count"
        case dqBucketCounts = "dq_bucket_counts"
        case medianPrice = "median_price"
        case lowestSgBasePrice = "lowest_sg_base_price"
        case lowestSgBasePriceGoodDeals = "lowest_sg_base_price_good_deals"
    }
}

enum Status: String, Codable {
    case normal = "normal"
}

// MARK: - Venue
struct Venue: Codable {
    let state, nameV2, postalCode, name: String
    let links: [JSONAny]
    let timezone: Timezone
    let url: String
    let score: Double
    let location: Location
    let address: String
    let country: Country
    let hasUpcomingEvents: Bool
    let numUpcomingEvents: Int
    let city, slug, extendedAddress: String
    let id, popularity: Int
    let accessMethod: AccessMethod?
    let metroCode, capacity: Int
    let displayLocation: String

    enum CodingKeys: String, CodingKey {
        case state
        case nameV2 = "name_v2"
        case postalCode = "postal_code"
        case name, links, timezone, url, score, location, address, country
        case hasUpcomingEvents = "has_upcoming_events"
        case numUpcomingEvents = "num_upcoming_events"
        case city, slug
        case extendedAddress = "extended_address"
        case id, popularity
        case accessMethod = "access_method"
        case metroCode = "metro_code"
        case capacity
        case displayLocation = "display_location"
    }
}

enum Country: String, Codable {
    case us = "US"
}

enum Timezone: String, Codable {
    case americaChicago = "America/Chicago"
    case americaIndianaIndianapolis = "America/Indiana/Indianapolis"
    case americaNewYork = "America/New_York"
}

// MARK: - Meta
struct Meta: Codable {
    let total, took, page, perPage: Int
    let geolocation: JSONNull?

    enum CodingKeys: String, CodingKey {
        case total, took, page
        case perPage = "per_page"
        case geolocation
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}


