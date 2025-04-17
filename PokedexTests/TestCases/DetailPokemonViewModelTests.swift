//
//  DetailPokemonViewModelTests.swift
//  Pokedex
//
//  Created by Elia Crocetta on 17/04/25.
//

import XCTest
@testable import Pokedex

final class DetailPokemonViewModelTests: XCTestCase {
    
    private var viewModel: DetailPokemonViewModel!
    
    private let pokemonToFetch = "ditto"
    private let idPokemonToFetch = 132
    private var pokemonInjected: Pokemon {
        Pokemon(name: pokemonToFetch, id: idPokemonToFetch)
    }
    
    override func setUpWithError() throws {
        viewModel = DetailPokemonViewModel(
            service: StubDetailPokemonService(),
            pokemon: pokemonInjected
        )
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testCheckPokemonInjected() {
        XCTAssertEqual(viewModel.pokemon.name, pokemonToFetch)
        XCTAssertEqual(viewModel.pokemon.id, idPokemonToFetch)
    }
    
    func testFetchPokemonDetailsSuccess() async throws {
        await viewModel.fetchPokemonDetails(name: pokemonToFetch)
        
        XCTAssertNotNil(viewModel.pokemonDetails)
    }
    
    func testFetchPokemonDetailsDetailsNotAvailable() async throws {
        await viewModel.fetchPokemonDetails(name: pokemonToFetch)
        
        let pokemonDetails = try XCTUnwrap(viewModel.pokemonDetails)
        XCTAssertEqual(pokemonDetails.name, pokemonToFetch)
        
        XCTAssertNotEqual(pokemonDetails.heightValue, "")
        XCTAssertNotEqual(pokemonDetails.weightValue, "")
    }
    
    func testPokemonAbilities() async throws {
        await viewModel.fetchPokemonDetails(name: pokemonToFetch)
        
        let pokemonDetails = try XCTUnwrap(viewModel.pokemonDetails)
        // Pokemon must always contains at least one hidden ability
        let abilities = try XCTUnwrap(pokemonDetails.abilitiesConverted)
        XCTAssertFalse(abilities.filter({$0.isAbilityHidden ?? false}).isEmpty)
    }
    
    func testPokemonMoves() async throws {
        await viewModel.fetchPokemonDetails(name: pokemonToFetch)
        
        let pokemonDetails = try XCTUnwrap(viewModel.pokemonDetails)
        // Pokemon must always contains no hidden moves
        let moves = try XCTUnwrap(pokemonDetails.movesConverted)
        XCTAssertTrue(moves.filter({$0.isAbilityHidden ?? false}).isEmpty)
    }
    
    func testFetchPokemonDetailsFailure() async throws {
        await viewModel.fetchPokemonDetails(name: "wrongName")
        
        XCTAssertNil(viewModel.pokemonDetails)
    }
    
    func testIsLoadingBehavior() async throws {
        XCTAssertFalse(viewModel.isLoading)
        await viewModel.fetchPokemonDetails(name: pokemonToFetch)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: Stubs utility
    private struct StubDetailPokemonService: DetailPokemonServiceProtocol, StubServiceProtocol {
        func fetchPokemonDetails(name: String) async throws -> PokemonDetails {
            let data = try fetchStub(named: .fetchSinglePokemon(name: name))
            return try JSONDecoder().decode(PokemonDetails.self, from: data)
        }
    }
}
