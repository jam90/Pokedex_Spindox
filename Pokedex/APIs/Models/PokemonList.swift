//
//  PokemonList.swift
//  Pokedex
//
//  Created by Elia Crocetta on 12/04/25.
//

import Foundation

struct PokemonList: Codable {
    private let next: String?
    
    let results: [PokemonListElement]
    var nextOffset: Int = 0
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.results = try container.decodeIfPresent([PokemonListElement].self, forKey: .results) ?? []
        if let next, let nextURLComponents = URLComponents(string: next) {
            let queryItems = nextURLComponents.queryItems ?? []
            let offsetQueryItem = queryItems.first(where: { $0.name == "offset" })
            self.nextOffset = Int(offsetQueryItem?.value ?? "0") ?? .defaultInt
        } else {
            self.nextOffset = 0
        }
    }
    
    struct PokemonListElement: ListElement, Identifiable, Equatable, Hashable {
        init(name: String, id: Int) {
            self.name = name
            self.url = Endpoint.pokemon(name: "\(id)/").url?.absoluteString
            self.id = id
        }
        
        var name: String
        var url: String?
        
        var id: Int
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: PokemonListElement.CodingKeys.self)
            self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
            self.url = try container.decodeIfPresent(String.self, forKey: .url)
            
            self.id = Int(self.url?.split(separator: "/").last ?? "0") ?? .defaultInt
        }
        
        var thumbnailURL: URL? {
            return Endpoint.imageThumbnail(id: id).url
        }
        
        var imageBigURL: URL? {
            return Endpoint.imageBig(id: id).url
        }
    }
}

protocol ListElement: Codable {
    var name: String { get }
    var url: String? { get }
}
