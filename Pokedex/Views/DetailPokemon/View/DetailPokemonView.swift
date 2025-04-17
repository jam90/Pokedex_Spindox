//
//  DetailPokemonView.swift
//  Pokedex
//
//  Created by Elia Crocetta on 14/04/25.
//

import SwiftUI

struct DetailPokemonView: View {
    @EnvironmentObject var coordinator: PokedexCoordinator
    @StateObject var viewModel: DetailPokemonViewModel
    @State private var isAbilitiesExpanded = false
    @State private var isMovesExpanded = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                header
                physicalChar
                abilitiesAndMoves
            }
            if viewModel.isLoading {
                loadingView
            }
        }
        .task {
            guard !viewModel.pokemon.name.isEmpty else { return }
            await viewModel.fetchPokemonDetails(name: viewModel.pokemon.name)
        }
    }
    
    /// Displays the Pokemon image and name in a vertical stack.
    @ViewBuilder
    private var header: some View {
        VStack(alignment: .center, spacing: 8) {
            if let url = viewModel.pokemon.imageBigURL {
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
                .frame(width: 160, height: 160)
                .aspectRatio(contentMode: .fit)
            } else {
                fallbackImage
            }
            
            Text(viewModel.pokemon.name.capitalized)
                .font(.title)
                .bold()
        }
    }
    
    /// Displays the height and weight of the Pokemon.
    ///
    /// Shows a loading indicator if data is not available yet.
    @ViewBuilder
    private var physicalChar: some View {
        if let pokemonDetails = viewModel.pokemonDetails {
            VStack(spacing: 4) {
                HStack(spacing: 0) {
                    Text("Height: ")
                        .accessibilityIdentifier(.detailPokemonHeight)
                    Text(pokemonDetails.heightValue)
                        .bold()
                }
                HStack(spacing: 0) {
                    Text("Weight: ")
                        .accessibilityIdentifier(.detailPokemonWeight)
                    Text(pokemonDetails.weightValue)
                        .bold()
                }
            }
        } else {
            ProgressView()
        }
    }
    
    /// Displays the lists of Pokemon's abilities and moves in a horizontal stack.
    @ViewBuilder
    private var abilitiesAndMoves: some View {
        HStack(spacing: 8) {
            listCreation(type: .abilities)
            listCreation(type: .moves)
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
    }
    
    /// Enum used to differentiate between abilities and moves list types.
    /// Used as differential parameter in `func listCreation(type: ListType) -> some View`
    private enum ListType {
        case abilities
        case moves
        
        var title: String {
            switch self {
            case .abilities:
                return "Abilities"
            case .moves:
                return "Moves"
            }
        }
        
        var accessibilityIdentifierHeader: PokedexAccessibilityIdentifier {
            switch self {
            case .abilities:
                return .detailPokemonAbilities
            case .moves:
                return .detailPokemonMoves
            }
        }
        
        var accessibilityIdentifierList: PokedexAccessibilityIdentifier {
            switch self {
            case .abilities:
                return .detailPokemonAbilitiesList
            case .moves:
                return .detailPokemonMovesList
            }
        }
        
        var accessibilityIdentifierElement: PokedexAccessibilityIdentifier {
            switch self {
            case .abilities:
                return .detailPokemonAbility
            case .moves:
                return .detailPokemonMove
            }
        }
    }
    
    /// Returns a list view for abilities or moves with expand/collapse behavior.
    ///
    /// - Parameter type: The list type to display (`.abilities` or `.moves`).
    @ViewBuilder
    private func listCreation(type: ListType) -> some View {
        var bindingExpandedValue: Binding<Bool> {
            switch type {
            case .abilities:
                $isAbilitiesExpanded
            case .moves:
                $isMovesExpanded
            }
        }
        
        var dataSource: [PokemonDetails.ElementList] {
            switch type {
            case .abilities:
                return viewModel.pokemonDetails?.abilitiesConverted ?? []
            case .moves:
                return viewModel.pokemonDetails?.movesConverted ?? []
            }
        }
        
        VStack(spacing: 0) {
            Button {
                bindingExpandedValue.wrappedValue.toggle()
            } label: {
                HStack {
                    Text(type.title)
                        .font(.headline)
                        .foregroundStyle(.black)
                        .accessibilityIdentifier(type.accessibilityIdentifierHeader)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.black)
                        .rotationEffect(.degrees(bindingExpandedValue.wrappedValue ? 90 : 0))
                        .animation(.easeInOut(duration: 0.2), value: bindingExpandedValue.wrappedValue)
                }
                .padding(.bottom)
            }
            List {
                Section(
                    isExpanded: bindingExpandedValue,
                    content: {
                        ForEach(dataSource, id: \.nameElement) { element in
                            createList(element: element, from: type)
                                .accessibilityIdentifier(type.accessibilityIdentifierElement)
                        }
                    },
                    header: {}
                )
            }
            .listStyle(.sidebar)
            .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
            .padding(.bottom, 24)
            .scrollContentBackground(.hidden)
            .accessibilityIdentifier(type.accessibilityIdentifierList)
        }
    }
    
    /// Creates a button-based view for a Pokemon ability or move, which opens a corresponding detail sheet.
    ///
    /// This view displays a name and, if applicable, a "Hidden" label for hidden abilities.
    /// On tap, it triggers the presentation of a detail sheet using the appropriate enum case based on the `ListType`.
    ///
    /// - Parameters:
    ///   - element: The Pokemon detail element to display (either an ability or a move).
    ///   - type: Specifies whether the element is an ability or a move, and determines which sheet to present.
    @ViewBuilder
    private func createList(element: PokemonDetails.ElementList, from type: ListType) -> some View {
        Button {
            switch type {
            case .abilities:
                coordinator.present(sheet: .detailCharacteristicAbility(element.nameElement ?? ""))
            case .moves:
                coordinator.present(sheet: .detailCharacteristicMove(element.nameElement ?? ""))
            }
        } label: {
            VStack {
                Text((element.nameElement ?? "").capitalized)
                if element.isAbilityHidden == true {
                    Text("(Hidden)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
        
    @ViewBuilder
    private var fallbackImage: some View {
        FallbackImage(size: 160)
    }
    
    @ViewBuilder
    private var loadingView: some View {
        LoadingView()
    }
}

#Preview {
    DetailPokemonView(
        viewModel: DetailPokemonViewModel(
            service: DetailPokemonService(
                session: .shared
            ),
            pokemon: PokemonList.PokemonListElement(
                name: "pikachu",
                id: 25
            )
        )
    )
}
