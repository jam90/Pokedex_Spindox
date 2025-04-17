//
//  HomePageView.swift
//  Pokedex
//
//  Created by Elia Crocetta on 12/04/25.
//

import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var coordinator: PokedexCoordinator
    @StateObject var viewModel: HomePageViewModel
    
    var body: some View {
        ZStack {
            if viewModel.pokemonList.isEmpty && !viewModel.isFirstLoading {
                errorEmptyState
            } else {
                pokemonList
            }
            if viewModel.isLoading {
                loadingView
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search a Pokemon")
        .navigationTitle("Pokedex")
        .task {
            await viewModel.fetchPokemonList()
        }
        .onChange(of: viewModel.searchText) { _, _ in
            guard viewModel.isSearching else { return }
            guard viewModel.filteredPokemons.isEmpty else { return }
            Task {
                await viewModel.searchIfNotFound()
            }
        }
        .accessibilityIdentifier(.homeMainStack)
    }
    
    /// A view that renders the list of Pokemon.
    ///
    /// Composed by a title, buttons for navigation and triggers additional fetches with increased offset when scrolling.
    @ViewBuilder
    private var pokemonList: some View {
        VStack {
            Text("Select the Pokemon to find out more about it!")
                .font(.body)
                .padding(.top)
            let arrayToFetch = viewModel.isSearching ? viewModel.filteredPokemons : viewModel.pokemonList
            List(arrayToFetch, id: \.id) { pokemon in
                Button {
                    hideKeyboard()
                    coordinator.push(screen: .detailPokemon(pokemon: pokemon))
                } label: {
                    PokemonListElementView(pokemon: pokemon)
                }
                .listRowSeparator(.hidden)
                .buttonStyle(.plain)
                .onAppear {
                    if viewModel.pokemonList.last?.id == pokemon.id {
                        Task {
                            await viewModel.fetchPokemonList()
                        }
                    }
                }
                .accessibilityIdentifier(.homePokemonListElement)
            }
        }
    }
    
    /// A view shown when the Pokemon list is empty and not in the initial loading state.
    ///
    /// Provides an error message and a retry button.
    @ViewBuilder
    private var errorEmptyState: some View {
        VStack {
            Text("Mmh, seems we got a problem! Don't worry, professor Oak is already working on it!")
                .font(.title2)
                .padding()
            Button("Retry") {
                Task {
                    await viewModel.fetchPokemonList()
                }
            }
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        LoadingView()
    }
}

fileprivate extension View {
    /// Sends an action to resign the first responder of the searchbar, hiding the keyboard.
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}

#Preview {
    HomePageView(viewModel: HomePageViewModel(service: HomePageService(session: .shared)))
}

