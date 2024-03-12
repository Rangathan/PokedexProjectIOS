//
//  PokemonDetails.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-10.
//

import Foundation
import Combine

struct PokemonDetails: Identifiable, Decodable {
    let id: Int?
    let name: String
    let weight: Int?
    let abilities: [Ability]
    let moves: [Move]
    let types: [Type]
    let stats: [Stat]
    let sprites: Sprites

    private enum CodingKeys: String, CodingKey {
        case id, name, weight, abilities, moves, types, stats, sprites
    }
}

extension Ability: Equatable {
    static func == (lhs: Ability, rhs: Ability) -> Bool {
        return lhs.ability == rhs.ability
    }
}

extension Ability: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ability)
    }
}





struct Sprites: Codable {
    let frontDefault: String
    let backDefault: String?

    private enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
    }
}

struct Ability: Codable {
    let ability: APIItem
}

struct Move: Codable {
    let move: APIItem
}

struct Type: Codable {
    let type: APIItem
}

struct Stat: Codable {
    let baseStat: Int
    let stat: APIItem

    private enum CodingKeys: String, CodingKey {
        case stat
        case baseStat = "base_stat"
    }
}

extension Sprites: Equatable {
    static func == (lhs: Sprites, rhs: Sprites) -> Bool {
        return lhs.frontDefault == rhs.frontDefault && lhs.backDefault == rhs.backDefault
    }
}

extension Sprites: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(frontDefault)
        hasher.combine(backDefault)
    }
}



extension Move: Equatable {
    static func == (lhs: Move, rhs: Move) -> Bool {
        return lhs.move == rhs.move
    }
}

extension Move: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(move)
    }
}

extension Type: Equatable {
    static func == (lhs: Type, rhs: Type) -> Bool {
        return lhs.type == rhs.type
    }
}

extension Type: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
    }
}

extension Stat: Equatable {
    static func == (lhs: Stat, rhs: Stat) -> Bool {
        return lhs.baseStat == rhs.baseStat && lhs.stat == rhs.stat
    }
}

extension Stat: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(baseStat)
        hasher.combine(stat)
    }
}


struct APIItem: Codable {
    let name: String
    let url: String
}

extension APIItem: Equatable {
    static func == (lhs: APIItem, rhs: APIItem) -> Bool {
        return lhs.name == rhs.name && lhs.url == rhs.url
    }
}

extension APIItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(url)
    }
}
