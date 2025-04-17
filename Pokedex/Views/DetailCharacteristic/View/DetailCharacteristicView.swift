//
//  DetailCharacteristicView.swift
//  Pokedex
//
//  Created by Elia Crocetta on 15/04/25.
//

import SwiftUI

struct DetailCharacteristicView: View {
    @EnvironmentObject var coordinator: PokedexCoordinator
    @StateObject var viewModel: DetailCharacteristicViewModel
    
    var body: some View {
        ZStack {
            NavigationView {
                if let ability = viewModel.ability {
                    abilityView(from: ability)
                        .navigationTitle("Ability")
                } else if let move = viewModel.move {
                    moveView(from: move)
                        .navigationTitle("Move")
                } else if !viewModel.isLoading && !viewModel.isFirstLoading {
                    errorView
                }
            }
            if viewModel.isLoading {
                loadingView
            }
        }
        .task {
            switch viewModel.elementPassed {
            case .ability(let name):
                await viewModel.fetchPokemonAbilities(name: name)
            case .move(let name):
                await viewModel.fetchPokemonMoves(name: name)
            }
        }
    }
    
    /// Returns the UI to show details about a Pokemon ability.
    ///
    /// - Parameter ability: The ability to display.
    @ViewBuilder
    private func abilityView(from ability: PokemonAbilities) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            staticListElement(with: "Name", value: ability.name.capitalized)
            descriptionElement(ability.effectEntries)
            VStack(alignment: .leading) {
                Text("Pokemon that could potentially have this ability")
                    .font(.subheadline)
                    .accessibilityIdentifier(.detailCharacteristicListDescription)
                List(ability.pokemon) { pokemon in
                    pokemonListElement(url: pokemon.thumbnailURL, name: pokemon.name)
                        .onTapGesture {
                            viewModel.pushPokemonFromList(from: coordinator, pokemon.convertedObject)
                        }
                        .accessibilityIdentifier(.detailCharacteristicPokemonWithAbility)
                }
                .scrollContentBackground(.hidden)
                .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
            }
        }
        .padding()
    }
    
    /// Returns the UI to show details about a Pokemon move.
    ///
    /// - Parameter move: The move to display.
    @ViewBuilder
    private func moveView(from move: PokemonMoves) -> some View {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("General info")
                            .font(.title3)
                            .accessibilityIdentifier(.detailCharacteristicGeneralInfo)
                        staticListElement(with: "Name", value: move.name.capitalized)
                        staticListElement(with: "Type", value: (move.type?.name ?? "").capitalized)
                        staticListElement(with: "Damage class", value: (move.damageClass?.name ?? "").capitalized)
                    }
                    VStack(alignment: .leading) {
                        Text("Battle info")
                            .font(.title3)
                            .accessibilityIdentifier(.detailCharacteristicBattleInfo)
                        staticListElement(with: "Accuracy", value: move.accuracy == .defaultInt ? "-" : "\(move.accuracy)%")
                        staticListElement(with: "Effect chance", value: move.effectChance == .defaultInt ? "-" : "\(move.effectChance)%")
                        staticListElement(with: "Power", value: move.power == .defaultInt ? "-" : "\(move.power)")
                    }
                }
                descriptionElement(move.effectEntries)
                VStack(alignment: .leading) {
                    Text("Pokemon that can learn the move")
                        .font(.subheadline)
                        .accessibilityIdentifier(.detailCharacteristicListDescription)
                    List (move.learnedByPokemon) { pokemon in
                        pokemonListElement(url: pokemon.thumbnailURL, name: pokemon.name)
                            .onTapGesture {
                                viewModel.pushPokemonFromList(from: coordinator, pokemon.convertedObject)
                            }
                            .accessibilityIdentifier(.detailCharacteristicPokemonWithMove)
                    }
                    .scrollContentBackground(.hidden)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
                }
        }
        .padding()
    }
    
    /// Returns a horizontal stack with key-value parameters to show
    ///
    /// - Parameters:
    ///   - key: The label of the element.
    ///   - value: The corresponding value to display.
    @ViewBuilder
    private func staticListElement(with key: String, value: String) -> some View {
        HStack(spacing: 8) {
            Text(key + ":")
                .font(.subheadline)
                .accessibilityIdentifier(.detailCharacteristicKey)
            Text(value)
                .font(.headline)
                .accessibilityIdentifier(.detailCharacteristicValue)
        }
    }
    
    /// Returns a vertical stack with the description and the title
    ///
    /// - Parameter description: A string containing the ability or move description.
    @ViewBuilder
    private func descriptionElement(_ description: String) -> some View {
        VStack(alignment: .leading) {
            Text("Description")
                .font(.title3)
                .accessibilityIdentifier(.detailCharacteristicDescription)
            Text(description)
                .font(.body)
                .accessibilityIdentifier(.detailCharacteristicDescriptionValue)
        }
    }
    
    /// Returns a Pokemon row with image and name.
    ///
    /// - Parameters:
    ///   - url: The URL for the thumbnail.
    ///   - name: The name of the Pokemon.
    @ViewBuilder
    private func pokemonListElement(url: URL?, name: String) -> some View {
        HStack(spacing: 8) {
            if let url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                    default:
                        fallbackImage
                    }
                }
                .frame(width: 80, height: 80)
                .aspectRatio(contentMode: .fit)
            } else {
                fallbackImage
            }
            
            Text(name.capitalized)
                .font(.headline)
        }
    }
    
    @ViewBuilder
    private var errorView: some View {
        VStack(spacing: 24) {
            Text("Ops! Something went wrong...")
            Button("Close") {
                coordinator.dismissSheet()
            }
        }
    }
    
    @ViewBuilder
    private var fallbackImage: some View {
        FallbackImage(size: 60)
    }
    
    @ViewBuilder
    private var loadingView: some View {
        LoadingView()
    }
}

#Preview {
    DetailCharacteristicView(viewModel: DetailCharacteristicViewModel(service: DetailCharacteristicService(session: .shared), elementPassed: .ability(name: "overgrow")))
}
