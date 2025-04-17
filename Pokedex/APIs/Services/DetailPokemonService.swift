//
//  DetailPokemonService.swift
//  Pokedex
//
//  Created by Elia Crocetta on 15/04/25.
//

import Foundation

protocol DetailPokemonServiceProtocol {
    func fetchPokemonDetails(name: String) async throws -> PokemonDetails
}

struct DetailPokemonService: APIManagerProtocol, DetailPokemonServiceProtocol {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchPokemonDetails(name: String) async throws -> PokemonDetails {
        do {
            return try await callApi(endPoint: .pokemon(name: name))
        } catch {
            throw APIError.unexpectedResponse
        }
    }
}
