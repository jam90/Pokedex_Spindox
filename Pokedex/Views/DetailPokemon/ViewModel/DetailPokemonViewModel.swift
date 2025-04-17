//
//  DetailPokemonViewModel.swift
//  Pokedex
//
//  Created by Elia Crocetta on 15/04/25.
//

import SwiftUI

final class DetailPokemonViewModel: ViewModelProtocol, ObservableObject {
    /// The  Pokemon model injected from presenter view.
    @Published var pokemon: Pokemon
    /// The detailed information about the Pokemon, fetched from the backend.
    @Published var pokemonDetails: PokemonDetails?
    @Published var isLoading: Bool = false
    
    private var service: DetailPokemonServiceProtocol
    
    /// Initializes the `DetailPokemonViewModel` with a service and a Pokemon model.
    ///
    /// - Parameters:
    ///   - service: A service conforming to `DetailPokemonServiceProtocol` used for fetching details.
    ///   - pokemon: The Pokemon to display in details.
    init(service: DetailPokemonServiceProtocol, pokemon: Pokemon) {
        self.pokemon = pokemon
        self.service = service
    }
    
    /// Fetches the detailed data for a given Pokemon name.
    ///
    /// - Parameter name: The name of the Pokemon to fetch details for.
    /// - Note: Fetch the Pokemon details and assign the model received to `pokemonDetails` or sets it to `nil` if an error occurs.
    @MainActor
    func fetchPokemonDetails(name: String) async {
        self.isLoading = true
        
        defer {
            self.isLoading = false
        }
        
        do {
            self.pokemonDetails = try await service.fetchPokemonDetails(name: name)
        } catch {
            self.pokemonDetails = nil
        }
    }
}
