//
//  HomePageViewModel.swift
//  Pokedex
//
//  Created by Elia Crocetta on 12/04/25.
//

import SwiftUI

typealias Pokemon = PokemonList.PokemonListElement

final class HomePageViewModel: ViewModelProtocol, ObservableObject {
    @Published var pokemonList: [Pokemon] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    
    private var service: HomePageServiceProtocol
    
    var isFirstLoading = true
    var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var nextOffset: Int = 0
    
    /// A computed list of Pokemon filtered by the current search text.
    /// Returns the full list if the user is not searching.
    var filteredPokemons: [Pokemon] {
        guard isSearching else {
            return pokemonList
        }
        let searchTextTrimmed = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return pokemonList.filter {$0.name.lowercased().contains(searchTextTrimmed)}
    }
    
    /// Initializes the `HomePageViewModel` with the provided service.
    ///
    /// - Parameter service: An instance conforming to `HomePageServiceProtocol` for data fetching.
    init(service: HomePageServiceProtocol) {
        self.service = service
    }
    
    /// Fetches a list of Pokemon from the backend service, than update `nextOffset` for the next fetching
    ///
    /// - Note: This function updates the `pokemonList` by merging the current list with new results,
    ///         ensuring uniqueness and sorted order by Pokemon ID. Also updates the `nextOffset`
    ///         for pagination and handles `isLoading` for loading state.
    ///
    @MainActor
    func fetchPokemonList() async {
        self.isLoading = true
        
        defer {
            self.isLoading = false
            if isFirstLoading {
                isFirstLoading.toggle()
            }
        }
        
        do {
            let pokemonList = try await service.fetchPokemonList(offset: self.nextOffset)
            self.nextOffset = pokemonList.nextOffset
            
            let pokemonListSelf = self.pokemonList
            let pokemonListResult = pokemonList.results
            let mergedArray = pokemonListSelf + pokemonListResult
            let mergedSet = Set(mergedArray)
            let arrayMerged = Array(mergedSet).sorted(by: {$0.id < $1.id})
            
            self.pokemonList = arrayMerged
            
            try await Task.sleep(for: .seconds(0.2))
        } catch {
            self.pokemonList = []
            self.nextOffset = 0
        }
    }
    
    /// Searches for a single Pokemon by name from the backend service if not already present in the list.
    ///
    /// - Note: This function trims and lowercases the `searchText`, attempts to fetch the Pokemon from the backend,
    ///         and appends it to `pokemonList` if not already included. The list is then sorted by Pokemon ID.
    ///
    @MainActor
    func searchIfNotFound() async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            try await Task.sleep(for: .seconds(0.5))
            let searchTextTrimmed = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            let searchedPokemon = try await service.fetchSinglePokemon(name: searchTextTrimmed)
            let convertedSearchedPokemon = searchedPokemon.convertedObject
            
            if !pokemonList.contains(where: { $0 == convertedSearchedPokemon }) {
                pokemonList.append(convertedSearchedPokemon)
            }
            self.pokemonList.sort(by: {$0.id < $1.id})
        } catch {
            return
        }
    }
    
}
