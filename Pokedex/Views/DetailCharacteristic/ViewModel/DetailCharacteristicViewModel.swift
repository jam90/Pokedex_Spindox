//
//  DetailCharacteristicViewModel.swift
//  Pokedex
//
//  Created by Elia Crocetta on 15/04/25.
//

import SwiftUI

final class DetailCharacteristicViewModel: ViewModelProtocol, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var ability: PokemonAbilities?
    @Published var move: PokemonMoves?
    
    private var service: DetailCharacteristicServiceProtocol
    
    var isFirstLoading = true
    
    /// The element (ability or move) that was passed for fetching details.
    let elementPassed: ElementPassed
    
    /// An enum representing whether the detail to fetch is an ability or a move, with the name of it.
    enum ElementPassed {
        case ability(name: String)
        case move(name: String)
    }
    
    /// Initializes the `DetailCharacteristicViewModel` with a service and an element type (ability or move).
    ///
    /// - Parameters:
    ///   - service: A service conforming to `DetailCharacteristicServiceProtocol` for fetching data.
    ///   - elementPassed: The type of element to fetch (ability or move).
    init(service: DetailCharacteristicServiceProtocol, elementPassed: ElementPassed) {
        self.service = service
        self.elementPassed = elementPassed
    }
    
    /// Navigates to the detail view of the Pokemon selected and handles `isLoading` for loading state.
    ///
    /// - Parameters:
    ///   - coordinator: The app’s coordinator for managing navigation.
    ///   - pokemon: The Pokemon selected.
    @MainActor
    func pushPokemonFromList(from coordinator: PokedexCoordinator, _ pokemon: Pokemon) {
        isLoading = true
        coordinator.pushPokemonFromList(pokemon) { [weak self] in
            self?.isLoading = false
        }
    }
    
    /// Fetches ability details for a Pokemon with a given name.
    ///
    /// - Parameter name: The name of the ability to fetch.
    /// - Note: Updates `ability` with the result or sets it to `nil` if the fetch fails.
    @MainActor
    func fetchPokemonAbilities(name: String) async {
        self.isLoading = true
        
        defer {
            self.isLoading = false
            if isFirstLoading {
                isFirstLoading.toggle()
            }
        }
        
        do {
            self.ability = try await service.fetchPokemonAbilities(name: name)
        } catch {
            self.ability = nil
        }
    }
    
    /// Fetches move details for a Pokemon with a given name.
    ///
    /// - Parameter name: The name of the move to fetch.
    /// - Note: Updates `move` with the result or sets it to `nil` if the fetch fails.
    @MainActor
    func fetchPokemonMoves(name: String) async {
        self.isLoading = true
        
        defer {
            self.isLoading = false
            if isFirstLoading {
                isFirstLoading.toggle()
            }
        }
        
        do {
            self.move = try await service.fetchPokemonMoves(name: name)
        } catch {
            self.move = nil
        }
    }
}
