//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Elia Crocetta on 12/04/25.
//

import Foundation

struct PokemonDetails: Codable {
    private let height: Int?
    private let weight: Int?
    private let abilities: [Abilities]?
    private let moves: [Moves]?
    
    let name: String
    let id: Int?
    var abilitiesConverted: [ElementList]?
    var movesConverted: [ElementList]?
    
    var heightValue: String {
        guard let height else { return "" }
        let heightDm: Measurement<UnitLength> = Measurement(value: Double(height), unit: .decimeters)
        let heightConverted = heightDm.converted(to: .meters)
        
        let valueFormatted = String(format: "%.2f", heightConverted.value) + " \(heightConverted.unit.symbol)"
        return valueFormatted.replacingOccurrences(of: ".", with: ",")
    }
    
    var weightValue: String {
        guard let weight else { return "" }
        let weightHg: Measurement<UnitMass> = Measurement(value: Double(weight), unit: .hectograms)
        let weightConverted = weightHg.converted(to: .kilograms)
        
        let valueFormatted = String(format: "%.2f", weightConverted.value) + " \(weightConverted.unit.symbol)"
        return valueFormatted.replacingOccurrences(of: ".", with: ",")
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.height = try container.decodeIfPresent(Int.self, forKey: .height)
        self.weight = try container.decodeIfPresent(Int.self, forKey: .weight)
        self.abilities = try container.decodeIfPresent([Abilities].self, forKey: .abilities)
        self.moves = try container.decodeIfPresent([Moves].self, forKey: .moves)
        
        self.abilitiesConverted = abilities?.reduce(into: [ElementList]()) { partialResult, element in
            partialResult.append(ElementList(nameElement: element.ability?.name, isAbilityHidden: element.isHidden))
        }
        self.movesConverted = moves?.reduce(into: [ElementList]()) { partialResult, element in
            partialResult.append(ElementList(nameElement: element.move?.name, isAbilityHidden: nil))
        }
    }
    
    var convertedObject: Pokemon {
        PokemonList.PokemonListElement(name: name, id: id ?? .defaultInt)
    }
    
    struct ElementList: Codable {
        let nameElement: String?
        let isAbilityHidden: Bool?
    }
    
    private struct Abilities: Codable {
        let ability: AbilitiesListElement?
        let isHidden: Bool?
        
        struct AbilitiesListElement: ListElement {
            let name: String
            let url: String?
            
            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
                self.url = try container.decodeIfPresent(String.self, forKey: .url)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case ability
            case isHidden = "is_hidden"
        }
    }
    
    private struct Moves: Codable {
        let move: MovesListElement?
        
        struct MovesListElement: ListElement {
            let name: String
            let url: String?
            
            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
                self.url = try container.decodeIfPresent(String.self, forKey: .url)
            }
        }
    }
}

fileprivate extension UnitMass {
    static let hectograms = UnitMass(symbol: "hg", converter: UnitConverterLinear(coefficient: 0.1))
}

fileprivate extension UnitLength {
    static let decimeters = UnitLength(symbol: "dm", converter: UnitConverterLinear(coefficient: 0.1))
}
