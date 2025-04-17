//
//  DetailCharacteristicService.swift
//  Pokedex
//
//  Created by Elia Crocetta on 15/04/25.
//

import Foundation

protocol DetailCharacteristicServiceProtocol {
    func fetchPokemonAbilities(name: String) async throws -> PokemonAbilities
    func fetchPokemonMoves(name: String) async throws -> PokemonMoves
}

struct DetailCharacteristicService: APIManagerProtocol, DetailCharacteristicServiceProtocol {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchPokemonAbilities(name: String) async throws -> PokemonAbilities {
        do {
            return try await callApi(endPoint: .abilities(name: name))
        } catch {
            throw APIError.unexpectedResponse
        }
    }
    
    func fetchPokemonMoves(name: String) async throws -> PokemonMoves {
        do {
            return try await callApi(endPoint: .moves(name: name))
        } catch {
            throw APIError.unexpectedResponse
        }
    }
}
