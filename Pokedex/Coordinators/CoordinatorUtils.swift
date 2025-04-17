//
//  CoordinatorUtils.swift
//  Pokedex
//
//  Created by Elia Crocetta on 14/04/25.
//

import SwiftUI

@MainActor
protocol PokedexCoordinatorProtocol: ObservableObject {
    /// The navigation path that keeps track of pushed screens.
    var path: NavigationPath { get set }
    
    /// The currently presented modal sheet, if any.
    var sheet: Sheet? { get set }
    
    /// Pushes a screen onto the navigation stack.
    ///
    /// - Parameter screen: The screen to be pushed.
    func push(screen: Screen)
    
    /// Presents a modal sheet.
    ///
    /// - Parameter sheet: The sheet to be presented.
    func present(sheet: Sheet)
    
    /// Pops the navigation stack.
    ///
    /// - Parameter root: If true, pops to the root of the stack. Otherwise, pops the top screen.
    func pop(root: Bool)
    
    /// Dismisses the currently presented sheet.
    func dismissSheet()
}

/// An enum representing all navigable screens in the Pokedex app.
///
/// Used for managing navigation state in the coordinator.
enum Screen: Identifiable, Hashable {
    case homePage
    case detailPokemon(pokemon: Pokemon)
    
    /// The screen's identity, required for conforming to `Identifiable` in order to be appended in `var path: NavigationPath`.
    var id: Self { return self }
}

/// Enum representing the types of sheets that can be presented in the app.
enum Sheet: Identifiable, Hashable {
    case detailCharacteristicAbility(_ ability: String)
    case detailCharacteristicMove(_ move: String)
    
    /// The sheet's identity, required for conforming to `Identifiable` in order to be binded in `.sheet(item: Binding<Item?>`.
    var id: Self { return self }
}
