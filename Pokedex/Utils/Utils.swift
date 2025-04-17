//
//  ViewModelProtocol.swift
//  Pokedex
//
//  Created by Elia Crocetta on 13/04/25.
//

import SwiftUI

/// The base protocol for view models.
protocol ViewModelProtocol {
    var isLoading: Bool { get set }
}

extension Int {
    /// Used as default value to unwrap `Int` nullable values.
    /// The value is `-1`.
    static let defaultInt: Int = -1
}

/// Enum for type-safe accessibility identifier
public enum PokedexAccessibilityIdentifier: String {
    /// HomePageView
    case homeMainStack
    case homePokemonListElement
    /// DetailPokemonView
    case detailPokemonAbility
    case detailPokemonAbilitiesList
    case detailPokemonAbilities
    case detailPokemonMove
    case detailPokemonMovesList
    case detailPokemonMoves
    case detailPokemonHeight
    case detailPokemonWeight
    /// DetailCharacteristicView
    case detailCharacteristicKey
    case detailCharacteristicValue
    case detailCharacteristicGeneralInfo
    case detailCharacteristicBattleInfo
    case detailCharacteristicDescription
    case detailCharacteristicDescriptionValue
    case detailCharacteristicListDescription
    case detailCharacteristicPokemonWithAbility
    case detailCharacteristicPokemonWithMove
}


extension View {
    public func accessibilityIdentifier(_ id: PokedexAccessibilityIdentifier) -> some View {
        return self.accessibilityIdentifier(id.rawValue)
    }
}
