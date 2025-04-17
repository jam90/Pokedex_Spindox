//
//  HomePageViewModelTests.swift
//  PokedexTests
//
//  Created by Elia Crocetta on 16/04/25.
//

import XCTest
@testable import Pokedex

final class HomePageViewModelTests: XCTestCase {
    
    private var viewModel: HomePageViewModel!
    private var localArray = [
        Pokemon(name: "bulbasaur", id: 1),
        Pokemon(name: "pikachu", id: 25)
    ]

    override func setUpWithError() throws {
        viewModel = HomePageViewModel(service: StubHomePageService())
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    // MARK: Pokemon lists' test
    func testFetchPokemonListSuccess() async throws {
        await viewModel.fetchPokemonList()

        XCTAssertEqual(viewModel.pokemonList.count, 20)
        
        let firstPokemon = try XCTUnwrap(viewModel.pokemonList.first)
        XCTAssertEqual(firstPokemon.id, 1)
        
        let lastPokemon = try XCTUnwrap(viewModel.pokemonList.last)
        XCTAssertEqual(lastPokemon.id, 20)
    }
    
    func testFetchPokemonListOffsetSuccess() async throws {
        viewModel.nextOffset = 20
        await viewModel.fetchPokemonList()

        XCTAssertEqual(viewModel.pokemonList.count, 20)
        
        let firstPokemon = try XCTUnwrap(viewModel.pokemonList.first)
        XCTAssertEqual(firstPokemon.id, 21)
        
        let lastPokemon = try XCTUnwrap(viewModel.pokemonList.last)
        XCTAssertEqual(lastPokemon.id, 40)
    }
    
    func testIsLoadingBehaviorWithFetchList() async throws {
        XCTAssertFalse(viewModel.isLoading)
        await viewModel.fetchPokemonList()
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testIsFirstLoadingBehavior() async throws {
        XCTAssertTrue(viewModel.isFirstLoading)
        await viewModel.fetchPokemonList()
        XCTAssertFalse(viewModel.isFirstLoading)
    }

    // MARK: Searching tests
    func testSearchIfNotFoundSuccess() async throws {
        let pokemon = "ditto"
        viewModel.searchText = pokemon
        await viewModel.searchIfNotFound()

        XCTAssertTrue(viewModel.pokemonList.contains(where: { $0.name == pokemon }))
    }

    func testSearchIfNotFoundFailure() async throws {
        let text = "pokemonMissing"
        viewModel.searchText = text
        await viewModel.searchIfNotFound()

        XCTAssertFalse(viewModel.pokemonList.contains(where: { $0.name == text }))
    }

    func testFilteredPokemonsWhenSearching() throws {
        let searchText = "bulba"
        let pokemonToBeFound = "bulbasaur"
        
        viewModel.pokemonList = localArray
        viewModel.searchText = searchText

        let filtered = viewModel.filteredPokemons
        XCTAssertEqual(filtered.count, 1)
        
        let firstPokemon = try XCTUnwrap(viewModel.pokemonList.first)
        XCTAssertEqual(firstPokemon.name, pokemonToBeFound)
    }

    func testFilteredPokemonsWhenSearchTextIsEmpty() {
        viewModel.pokemonList = localArray
        viewModel.searchText = ""

        let filtered = viewModel.filteredPokemons
        XCTAssertEqual(filtered.count, localArray.count)
    }
    
    func testIsLoadingBehaviorWithFetchSingle() async throws {
        XCTAssertFalse(viewModel.isLoading)
        await viewModel.searchIfNotFound()
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: Stubs utility
    private struct StubHomePageService: HomePageServiceProtocol, StubServiceProtocol {
        func fetchPokemonList(offset: Int) async throws -> PokemonList {
            let data = try fetchStub(named: .fetchPokemonList(offset: offset))
            return try JSONDecoder().decode(PokemonList.self, from: data)
        }
        
        func fetchSinglePokemon(name: String) async throws -> PokemonDetails {
            let data = try fetchStub(named: .fetchSinglePokemon(name: name))
            return try JSONDecoder().decode(PokemonDetails.self, from: data)
        }
    }
}
