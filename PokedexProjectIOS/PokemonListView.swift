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
    let dimensions: Double = 140
    @ObservedObject var viewModel: PokemonListViewModel
    
    var body: some View {
        VStack {
            if let details = viewModel.pokemonDetails[pokemon.name] {
                VStack {
                    if let spriteURL = URL(string: details.sprites.frontDefault) {
                        AsyncImage(url: spriteURL) { image in
                            image
                                
                                 // Fixed size for image
                        } placeholder: {
                            ProgressView()
                                .frame(width: dimensions, height: dimensions)
                        }
                    }
                    
                    Text(pokemon.name)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .frame(width: dimensions) // Fixed width for text
                }
                .padding(8)
                .background(determineBackgroundColor())
                .clipShape(Circle())
                // Half of the width of VStack container
                // Fixed size for VStack container
            } else {
                ProgressView()
                    .onAppear {
                        viewModel.fetchPokemonDetails(for: pokemon)
                    }
                    .clipShape(Circle())
            }
        }
    }
    private func determineBackgroundColor() -> Color {
            guard let details = viewModel.pokemonDetails[pokemon.name],
                  let type = details.types.first?.type.name.lowercased() else {
                // Default color if details are not available
                return Color.gray
            }
            
            switch type {
                case "grass":
                    return Color.green
                case "fire":
                    return Color.red
                case "water":
                    return Color.blue
                case "electric":
                    return Color(red: 1, green: 1, blue: 1) // White
                case "psychic":
                    return Color.black
                case "fighting":
                    return Color(red: 1, green: 1, blue: 1) // White
                case "flying":
                    return Color(red: 1, green: 1, blue: 1) // White
                case "poison":
                    return Color.green
                default:
                    return Color.gray
            }
        }
}


extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}









    
    
    
    









