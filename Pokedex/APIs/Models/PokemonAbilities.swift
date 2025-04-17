//
//  PokemonAbilities.swift
//  Pokedex
//
//  Created by Elia Crocetta on 15/04/25.
//

import Foundation

struct PokemonAbilities: Codable {
    let name: String
    let effectEntries: String
    let pokemon: [PokemonObject]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        let effectEntries = try container.decodeIfPresent([EffectEntries].self, forKey: .effectEntries)
        self.effectEntries = effectEntries?.first(where: {$0.language?.name == "en"})?.shortEffect ?? ""
        self.pokemon = try container.decodeIfPresent([PokemonObject].self, forKey: .pokemon) ?? []
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case effectEntries = "effect_entries"
        case pokemon
    }
    
    struct EffectEntries: Codable {
        let shortEffect: String?
        let language: LanguageListElement?
        
        enum CodingKeys: String, CodingKey {
            case shortEffect = "short_effect"
            case language
        }
        
        struct LanguageListElement: ListElement {
            var name: String
            var url: String?
            
            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
                self.url = try container.decodeIfPresent(String.self, forKey: .url)
            }
        }
    }

    struct PokemonObject: Codable, Identifiable {
        private let pokemon: PokemonObjectListElement?
        var name: String {
            return pokemon?.name ?? ""
        }
        var id: Int {
            Int(pokemon?.url?.split(separator: "/").last ?? "0") ?? .defaultInt
        }
        
        var thumbnailURL: URL? {
            Endpoint.imageThumbnail(id: id).url
        }
        
        var convertedObject: Pokemon {
            PokemonList.PokemonListElement(name: name, id: id)
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.pokemon = try container.decodeIfPresent(PokemonObjectListElement.self, forKey: PokemonObject.CodingKeys.pokemon)
        }
        
        struct PokemonObjectListElement: ListElement {
            var name: String
            var url: String?
            
            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
                self.url = try container.decodeIfPresent(String.self, forKey: .url)
            }
        }
    }
}
