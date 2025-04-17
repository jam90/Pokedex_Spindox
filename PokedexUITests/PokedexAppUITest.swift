//
//  PokedexAppUITest.swift
//  HomePageViewUITests
//
//  Created by Elia Crocetta on 12/04/25.
//

import XCTest

final class PokedexAppUITest: XCTestCase {
    
    private var app: XCUIApplication!
    private let searchText = "bulbasaur"

    override func setUpWithError() throws {
        continueAfterFailure = false
        self.app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        self.app = nil
    }
    
    // MARK: UITests of HomePageView

    func testShowHomePageAsStartView() throws {
        let homeMainStack = app.staticTexts[.homeMainStack]
        XCTAssertTrue(homeMainStack.exists)
        
        let homePokemonList = app.collectionViews.firstMatch
        let hasAtLeastOnePokemonCell = homePokemonList.buttons.count > 0
        XCTAssertTrue(hasAtLeastOnePokemonCell)
    }

    func testHomeSearchPokemon() throws {
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText(searchText)
                
        XCTAssertTrue(homePokemonListFirstElement.waitForExistence(timeout: 2))
    }

    // MARK: UITests of DetailPokemonView
    
    func testNavigateToDetailPokemon() throws {
        openFirstPokemonDetail()
        
        XCTAssertTrue(app.staticTexts[.detailPokemonAbilities].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts[.detailPokemonMoves].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts[.detailPokemonHeight].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts[.detailPokemonWeight].waitForExistence(timeout: 2))
        XCTAssertTrue(app.collectionViews[.detailPokemonAbilitiesList].waitForExistence(timeout: 2))
        XCTAssertTrue(app.collectionViews[.detailPokemonMovesList].waitForExistence(timeout: 2))
    }

    // MARK: UITests of DetailCharacteristicView
    
    func testNavigateToDetailAbilityCharacteristic() throws {
        openFirstPokemonDetail()
        
        XCTAssertTrue(detailPokemonAbilities.waitForExistence(timeout: 2))
        detailPokemonAbilities.tap()
                  
        let singleAbilityButton = app.buttons[.detailPokemonAbility].firstMatch
        XCTAssertTrue(singleAbilityButton.waitForExistence(timeout: 2))
        singleAbilityButton.tap()
        
        let nameKey = app.staticTexts[.detailCharacteristicKey].firstMatch
        XCTAssertTrue(nameKey.waitForExistence(timeout: 2))
        let nameValue = app.staticTexts[.detailCharacteristicValue].firstMatch
        XCTAssertTrue(nameValue.waitForExistence(timeout: 2))
        
        let description = app.staticTexts[.detailCharacteristicDescription].firstMatch
        XCTAssertTrue(description.waitForExistence(timeout: 2))
        let descriptionValue = app.staticTexts[.detailCharacteristicDescriptionValue].firstMatch
        XCTAssertTrue(descriptionValue.waitForExistence(timeout: 2))
        
        let listDescription = app.staticTexts[.detailCharacteristicListDescription].firstMatch
        XCTAssertTrue(listDescription.waitForExistence(timeout: 2))
        
        let onePokemonWithAbility = app.staticTexts[.detailCharacteristicPokemonWithAbility].firstMatch
        XCTAssertTrue(onePokemonWithAbility.waitForExistence(timeout: 2))
    }

    func testNavigateToDetailMoveCharacteristic() throws {
        openFirstPokemonDetail()
        
        let movesSection = app.staticTexts[.detailPokemonMoves].firstMatch
        XCTAssertTrue(movesSection.waitForExistence(timeout: 2))
        movesSection.tap()
        
        let singleMoveButton = app.buttons[.detailPokemonMove].firstMatch
        XCTAssertTrue(singleMoveButton.waitForExistence(timeout: 2))
        singleMoveButton.tap()
        
        let generalInfo = app.staticTexts[.detailCharacteristicGeneralInfo].firstMatch
        XCTAssertTrue(generalInfo.waitForExistence(timeout: 2))
        let nameKey = app.staticTexts[.detailCharacteristicKey].firstMatch
        XCTAssertTrue(nameKey.waitForExistence(timeout: 2))
        let nameValue = app.staticTexts[.detailCharacteristicValue].firstMatch
        XCTAssertTrue(nameValue.waitForExistence(timeout: 2))
        let typeKey = app.staticTexts[.detailCharacteristicKey].firstMatch
        XCTAssertTrue(typeKey.waitForExistence(timeout: 2))
        let typeValue = app.staticTexts[.detailCharacteristicValue].firstMatch
        XCTAssertTrue(typeValue.waitForExistence(timeout: 2))
        let damageClassKey = app.staticTexts[.detailCharacteristicKey].firstMatch
        XCTAssertTrue(damageClassKey.waitForExistence(timeout: 2))
        let damageClassValue = app.staticTexts[.detailCharacteristicValue].firstMatch
        XCTAssertTrue(damageClassValue.waitForExistence(timeout: 2))
        
        let battleInfo = app.staticTexts[.detailCharacteristicBattleInfo].firstMatch
        XCTAssertTrue(battleInfo.waitForExistence(timeout: 2))
        let accuracyKey = app.staticTexts[.detailCharacteristicKey].firstMatch
        XCTAssertTrue(accuracyKey.waitForExistence(timeout: 2))
        let accuracyValue = app.staticTexts[.detailCharacteristicValue].firstMatch
        XCTAssertTrue(accuracyValue.waitForExistence(timeout: 2))
        let effectChanceKey = app.staticTexts[.detailCharacteristicKey].firstMatch
        XCTAssertTrue(effectChanceKey.waitForExistence(timeout: 2))
        let effectChanceValue = app.staticTexts[.detailCharacteristicValue].firstMatch
        XCTAssertTrue(effectChanceValue.waitForExistence(timeout: 2))
        let powerKey = app.staticTexts[.detailCharacteristicKey].firstMatch
        XCTAssertTrue(powerKey.waitForExistence(timeout: 2))
        let powerValue = app.staticTexts[.detailCharacteristicValue].firstMatch
        XCTAssertTrue(powerValue.waitForExistence(timeout: 2))
        
        let description = app.staticTexts[.detailCharacteristicDescription].firstMatch
        XCTAssertTrue(description.waitForExistence(timeout: 2))
        let descriptionValue = app.staticTexts[.detailCharacteristicDescriptionValue].firstMatch
        XCTAssertTrue(descriptionValue.waitForExistence(timeout: 2))
        
        let listDescription = app.staticTexts[.detailCharacteristicListDescription].firstMatch
        XCTAssertTrue(listDescription.waitForExistence(timeout: 2))
        
        let onePokemonWithMove = app.staticTexts[.detailCharacteristicPokemonWithMove].firstMatch
        XCTAssertTrue(onePokemonWithMove.waitForExistence(timeout: 2))
    }

    func testOpenPokemonDetailFromDetailCharacteristicAbility() {
        openFirstPokemonDetail()
        
        let abilitySection = app.staticTexts[.detailPokemonAbilities].firstMatch
        XCTAssertTrue(abilitySection.waitForExistence(timeout: 2))
        abilitySection.tap()
        
        let singleAbilityButton = app.buttons[.detailPokemonAbility].firstMatch
        XCTAssertTrue(singleAbilityButton.waitForExistence(timeout: 2))
        singleAbilityButton.tap()
        
        let firstPokemonWithAbility = app.staticTexts[.detailCharacteristicPokemonWithAbility].firstMatch
        firstPokemonWithAbility.tap()
        
        XCTAssertTrue(app.staticTexts[.detailPokemonAbilities].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts[.detailPokemonMoves].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts[.detailPokemonHeight].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts[.detailPokemonWeight].waitForExistence(timeout: 5))
    }

    func testOpenPokemonDetailFromDetailCharacteristicMove() {
        openFirstPokemonDetail()
        
        let movesSection = app.staticTexts[.detailPokemonMoves].firstMatch
        XCTAssertTrue(movesSection.waitForExistence(timeout: 2))
        movesSection.tap()
        
        let singleMoveButton = app.buttons[.detailPokemonMove].firstMatch
        XCTAssertTrue(singleMoveButton.waitForExistence(timeout: 2))
        singleMoveButton.tap()
        
        let firstPokemonWithMove = app.staticTexts[.detailCharacteristicPokemonWithMove].firstMatch
        XCTAssertTrue(firstPokemonWithMove.waitForExistence(timeout: 2))
        firstPokemonWithMove.tap()
        
        XCTAssertTrue(app.staticTexts[.detailPokemonAbilities].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts[.detailPokemonMoves].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts[.detailPokemonHeight].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts[.detailPokemonWeight].waitForExistence(timeout: 5))
    }
}

extension PokedexAppUITest {
    var homePokemonListFirstElement: XCUIElement {
        let homePokemonList = app.collectionViews.firstMatch
        return homePokemonList.buttons[.homePokemonListElement].firstMatch
    }
    
    var detailPokemonAbilities: XCUIElement { app.staticTexts[.detailPokemonAbilities].firstMatch }
    
    func openFirstPokemonDetail() {
        XCTAssertTrue(homePokemonListFirstElement.waitForExistence(timeout: 2))
        homePokemonListFirstElement.tap()
    }
}
