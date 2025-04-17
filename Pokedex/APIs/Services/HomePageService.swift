//
//  HomePageServices.swift
//  Pokedex
//
//  Created by Elia Crocetta on 12/04/25.
//

import Foundation

protocol HomePageServiceProtocol {
    func fetchPokemonList(offset: Int) async throws -> PokemonList
    func fetchSinglePokemon(name: String) async throws -> PokemonDetails
}

struct HomePageService: APIManagerProtocol, HomePageServiceProtocol {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchPokemonList(offset: Int) async throws -> PokemonList {
        do {
            return try await callApi(endPoint: .list(offset: offset))
        } catch {
            throw APIError.unexpectedResponse
        }
    }
    
    func fetchSinglePokemon(name: String) async throws -> PokemonDetails {
        do {
            return try await callApi(endPoint: .pokemon(name: name))
        } catch {
            throw APIError.unexpectedResponse
        }
    }
}
