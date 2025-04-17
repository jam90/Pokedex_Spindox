//
//  DetailCharacteristicViewModelTests.swift
//  Pokedex
//
//  Created by Elia Crocetta on 17/04/25.
//

import XCTest
@testable import Pokedex

final class DetailCharacteristicViewModelTests: XCTestCase {
    
    private var viewModel: DetailCharacteristicViewModel!
    
    /// Change the value of this enum to test both cases
    private var elementToTest: ElementToTest = .move
    
    private enum ElementToTest {
        case ability
        case move
        
        var name: String {
            switch self {
            case .ability:
                return "limber"
            case .move:
                //return "transform"
                return "skull-bash"
            }
        }
    }
    
    override func setUpWithError() throws {
        var elementInjected: DetailCharacteristicViewModel.ElementPassed {
            switch elementToTest {
            case .ability:
                DetailCharacteristicViewModel.ElementPassed.ability(name: elementToTest.name)
            case .move:
                DetailCharacteristicViewModel.ElementPassed.move(name: elementToTest.name)
            }
        }
        
        viewModel = DetailCharacteristicViewModel(service: StubDetailCharacteristicService(), elementPassed: elementInjected)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFetchPokemonAbilitiesMovesSuccess() async throws {
        switch viewModel.elementPassed {
        case .ability(let name):
            await viewModel.fetchPokemonAbilities(name: name)
            XCTAssertNotNil(viewModel.ability)
            XCTAssertNil(viewModel.move)
        case .move(let name):
            await viewModel.fetchPokemonMoves(name: name)
            XCTAssertNotNil(viewModel.move)
            XCTAssertNil(viewModel.ability)
        }
    }
    
    func testFetchPokemonAbilitiesMovesDetails() async throws {
        switch viewModel.elementPassed {
        case .ability(let name):
            await viewModel.fetchPokemonAbilities(name: name)
            
            let abilityUnwrap = try XCTUnwrap(viewModel.ability)
            
            XCTAssertEqual(abilityUnwrap.name, elementToTest.name)
            XCTAssertNotEqual(abilityUnwrap.effectEntries, "")
            XCTAssertFalse(abilityUnwrap.pokemon.isEmpty)
        case .move(let name):
            await viewModel.fetchPokemonMoves(name: name)
            
            let moveUnwrap = try XCTUnwrap(viewModel.move)
            
            XCTAssertEqual(moveUnwrap.name, elementToTest.name)
            XCTAssertNotNil(moveUnwrap.type)
            XCTAssertNotNil(moveUnwrap.damageClass)
            
            /// These values expected nullable sometimes, so we must check if the values is equal o greater then the defaultInt
            /// To test with null values, comment at line 28 and uncomment line 27, viceversa to test with values
            XCTAssertGreaterThanOrEqual(moveUnwrap.accuracy, Int.defaultInt)
            XCTAssertGreaterThanOrEqual(moveUnwrap.effectChance, Int.defaultInt)
            XCTAssertGreaterThanOrEqual(moveUnwrap.power, Int.defaultInt)
            
            XCTAssertNotEqual(moveUnwrap.effectEntries, "")
            
            XCTAssertFalse(moveUnwrap.learnedByPokemon.isEmpty)
        }
    }
    
    func testIsLoadingBehavior() async throws {
        XCTAssertFalse(viewModel.isLoading)
        switch viewModel.elementPassed {
        case .ability(let name):
            await viewModel.fetchPokemonAbilities(name: name)
        case .move(let name):
            await viewModel.fetchPokemonMoves(name: name)
        }
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testIsFirstLoadingBehavior() async throws {
        XCTAssertTrue(viewModel.isFirstLoading)
        switch viewModel.elementPassed {
        case .ability(let name):
            await viewModel.fetchPokemonAbilities(name: name)
        case .move(let name):
            await viewModel.fetchPokemonMoves(name: name)
        }
        XCTAssertFalse(viewModel.isFirstLoading)
    }
    
    // MARK: Stubs utility
    private struct StubDetailCharacteristicService: DetailCharacteristicServiceProtocol, StubServiceProtocol {
        func fetchPokemonAbilities(name: String) async throws -> PokemonAbilities {
            let data = try fetchStub(named: .fetchAbilities(name: name))
            return try JSONDecoder().decode(PokemonAbilities.self, from: data)
        }
        
        func fetchPokemonMoves(name: String) async throws -> PokemonMoves {
            let data = try fetchStub(named: .fetchMoves(name: name))
            return try JSONDecoder().decode(PokemonMoves.self, from: data)
        }
    }
}
