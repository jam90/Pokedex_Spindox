//
//  PokedexTestsUtilities.swift
//  Pokedex
//
//  Created by Elia Crocetta on 16/04/25.
//
import XCTest

protocol StubServiceProtocol {
    func fetchStub(named name: StubResourcesName) throws -> Data
}

extension StubServiceProtocol {
    func fetchStub(named name: StubResourcesName) throws -> Data {
        guard let url = Bundle.main.url(forResource: name.value, withExtension: "json") else {
            return Data()
        }
        
        return try Data(contentsOf: url)
    }
    
}

enum StubResourcesName {
    case fetchPokemonList(offset: Int)
    case fetchSinglePokemon(name: String)
    case fetchAbilities(name: String)
    case fetchMoves(name: String)
    
    var value: String {
        switch self {
        case let .fetchPokemonList(offset):
            return "fetch_pokemon_list_offset_\(offset)"
        case let .fetchSinglePokemon(name):
            return "fetch_single_pokemon_\(name)"
        case let .fetchAbilities(name):
            return "fetch_pokemon_abilities_\(name)"
        case let .fetchMoves(name):
            return "fetch_pokemon_moves_\(name)"
        }
    }
}
