//
//  Place.swift
//  Shisheo
//
//  Created by Arina Nefedova on 26.07.2021.
//
import Foundation

struct Place: Codable {
    var id = UUID().uuidString
    let name, offer, description, image_url: String

    enum CodingKeys: String, CodingKey {
        case name, offer, description, image_url
    }
}

// MARK: Convenience initializers

extension Place {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Place.self, from: data) else { return nil }
        self = me
    }
}
