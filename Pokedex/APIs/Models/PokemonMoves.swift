//
//  PokemonMoves.swift
//  Pokedex
//
//  Created by Elia Crocetta on 15/04/25.
//

import Foundation

struct PokemonMoves: Codable {
    let name: String
    let accuracy: Int
    let effectChance: Int
    let power: Int
    let damageClass: DamageClassListElement?
    let effectEntries: String
    let type: TypeListElement?
    let learnedByPokemon: [LearnedByPokemonListElement]
    
    enum CodingKeys: String, CodingKey {
        case name
        case accuracy
        case effectChance = "effect_chance"
        case power
        case damageClass = "damage_class"
        case effectEntries = "effect_entries"
        case type
        case learnedByPokemon = "learned_by_pokemon"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.accuracy = try container.decodeIfPresent(Int.self, forKey: .accuracy) ?? .defaultInt
        self.effectChance = try container.decodeIfPresent(Int.self, forKey: .effectChance) ?? .defaultInt
        self.power = try container.decodeIfPresent(Int.self, forKey: .power) ?? .defaultInt
        self.damageClass = try container.decodeIfPresent(DamageClassListElement.self, forKey: .damageClass)
        let effectEntries = try container.decodeIfPresent([PokemonAbilities.EffectEntries].self, forKey: .effectEntries)
        self.effectEntries = effectEntries?.first(where: {$0.language?.name == "en"})?.shortEffect ?? ""
        self.type = try container.decodeIfPresent(TypeListElement.self, forKey: .type)
        self.learnedByPokemon = try container.decodeIfPresent([LearnedByPokemonListElement].self, forKey: .learnedByPokemon) ?? []
    }
    
    struct DamageClassListElement: ListElement {
        var name: String
        var url: String?
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
            self.url = try container.decodeIfPresent(String.self, forKey: .url)
        }
    }
    
    struct TypeListElement: ListElement {
        var name: String
        var url: String?
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
            self.url = try container.decodeIfPresent(String.self, forKey: .url)
        }
    }
    
    struct LearnedByPokemonListElement: ListElement, Identifiable {
        var name: String
        var url: String?
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
            self.url = try container.decodeIfPresent(String.self, forKey: .url)
        }
        
        var id: Int {
            Int(url?.split(separator: "/").last ?? "0") ?? .defaultInt
        }
        
        var thumbnailURL: URL? {
            return Endpoint.imageThumbnail(id: id).url
        }
        
        var convertedObject: Pokemon {
            PokemonList.PokemonListElement(name: name, id: id)
        }
    }
}
