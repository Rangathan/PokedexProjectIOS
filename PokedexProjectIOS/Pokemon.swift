//
//  Pokemon.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-05.
//

import Foundation


struct PokemonPage: Codable {
    let count: Int
    let next: String?
    let results: [Pokemon]

    // Implement encode(to:) method
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(count, forKey: .count)
        try container.encode(next, forKey: .next)
        try container.encode(results, forKey: .results)
    }

    // Define CodingKeys enum
    private enum CodingKeys: String, CodingKey {
        case count, next, results
    }
}

struct Pokemon: Identifiable, Decodable, Hashable, Encodable {
    let id: UUID?
    let name: String
    let url: String
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, url
    }
}







