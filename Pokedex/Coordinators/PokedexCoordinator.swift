//
//  PokedexCoordinator.swift
//  Pokedex
//
//  Created by Elia Crocetta on 14/04/25.
//

import SwiftUI

final class PokedexCoordinator: PokedexCoordinatorProtocol {
    @Published var path: NavigationPath
    @Published var sheet: Sheet?
    
    /// Initializes the coordinator with an initial navigation path.
    ///
    /// - Parameter path: The initial navigation path.
    init(path: NavigationPath) {
        self.path = path
    }
    
    func push(screen: Screen) {
        path.append(screen)
    }
    
    func present(sheet: Sheet) {
        self.sheet = sheet
    }
    
    func pop(root: Bool) {
        if root {
            path.removeLast(path.count)
        } else {
            path.removeLast()
        }
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    /// Dismisses any presented sheet, resets the navigation stack, and pushes the detail screen for a Pokemon.
    ///
    /// This method is used after selecting a Pokemon from a sheet.
    /// It ensures the UI is reset by:
    /// - Dismissing any currently presented sheet.
    /// - Popping to the root of the navigation stack.
    /// - Delaying execution slightly to allow transitions to complete.
    /// - Finally pushing the `.detailPokemon` screen for the selected Pokemon.
    ///
    /// - Parameters:
    ///   - pokemon: The Pokemon to display in detail.
    ///   - completion: A closure called after the navigation transition finishes.
    func pushPokemonFromList(_ pokemon: Pokemon, completion: @escaping(() -> Void)) {
        dismissSheet()
        pop(root: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.push(screen: .detailPokemon(pokemon: pokemon))
            completion()
        }
    }
    
    /// Starts the app’s navigation flow with the initial screen.
    ///
    /// - Parameter urlSession: The URLSession to inject into services.
    /// - Returns: The initial view.
    @ViewBuilder
    func start(urlSession: URLSession) -> some View {
        create(screen: .homePage, urlSession: urlSession)
    }
    
    /// Creates a view for a given screen in the navigation flow.
    ///
    /// - Parameters:
    ///   - screen: The screen to create.
    ///   - urlSession: The URLSession to inject into services.
    /// - Returns: The requested view.
    @ViewBuilder
    func create(screen: Screen, urlSession: URLSession) -> some View {
        switch screen {
        case .homePage:
            HomePageView(viewModel: HomePageViewModel(service: HomePageService(session: urlSession)))
        case .detailPokemon(let pokemon):
            DetailPokemonView(viewModel: DetailPokemonViewModel(service: DetailPokemonService(session: urlSession), pokemon: pokemon))
        }
    }
    
    /// Creates a view for a given sheet to be presented.
    ///
    /// - Parameters:
    ///   - sheet: The sheet to create.
    ///   - urlSession: The URLSession to inject into services.
    /// - Returns: The requested sheet.
    @ViewBuilder
    func create(sheet: Sheet, urlSession: URLSession) -> some View {
        switch sheet {
        case .detailCharacteristicAbility(let ability):
            DetailCharacteristicView(
                viewModel: DetailCharacteristicViewModel(
                    service: DetailCharacteristicService(session: urlSession),
                    elementPassed: .ability(name: ability)
                )
            )
        case .detailCharacteristicMove(let move):
            DetailCharacteristicView(
                viewModel: DetailCharacteristicViewModel(
                    service: DetailCharacteristicService(session: urlSession),
                    elementPassed: .move(name: move)
                )
            )
        }
    }
}
