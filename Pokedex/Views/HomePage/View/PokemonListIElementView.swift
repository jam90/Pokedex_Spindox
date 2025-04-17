//
//  PokemonListIElementView.swift
//  Pokedex
//
//  Created by Elia Crocetta on 13/04/25.
//

import SwiftUI

struct PokemonListElementView: View {
    private var pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            if let url = pokemon.thumbnailURL {
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
            Text(pokemon.name.capitalized)
                .font(.body)
                .padding(.bottom)
            Divider()
        }
        .background(.white)
    }
    
    @ViewBuilder
    private var fallbackImage: some View {
        FallbackImage(size: 60)
    }
}

#Preview {
    PokemonListElementView(pokemon: PokemonList.PokemonListElement(name: "bulbasaur", id: 1))
}
