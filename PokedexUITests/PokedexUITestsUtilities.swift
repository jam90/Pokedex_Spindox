//
//  PokedexUITestsUtilities.swift
//  Pokedex
//
//  Created by Elia Crocetta on 17/04/25.
//

import XCTest
@testable import Pokedex

extension XCUIElementQuery {
    public subscript(_ id: PokedexAccessibilityIdentifier) -> XCUIElement {
        return self[id.rawValue]
    }


    public subscript(_ id: PokedexAccessibilityIdentifier, boundBy index: Int) -> XCUIElement {
        return self.matching(identifier: id.rawValue).element(boundBy: index)
    }
}
