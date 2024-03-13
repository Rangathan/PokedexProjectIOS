//
//  PokemonListView.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-05.
//

import SwiftUI
import Combine





struct PokemonItemViewContainer: View {
    let pokemon: Pokemon
    @ObservedObject var viewModel: PokemonListViewModel
    
    var body: some View {
        if let details = viewModel.pokemonDetails[pokemon.name] {
            VStack {
                if let spriteURL = URL(string: details.sprites.frontDefault) {
                    AsyncImage(url: spriteURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Text(pokemon.name)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .padding(8)
            .background(Color.blue)
            .cornerRadius(8)
        } else {
            ProgressView()
                .onAppear {
                    viewModel.fetchPokemonDetails(for: pokemon)
                }
        }
    }
}



extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}

struct PokemonItemViewPlaceholder: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.gray)
            .aspectRatio(1, contentMode: .fit)
    }
}








    
    
    
    









