//
//  ContentView.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-05.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var selectedPokemon: Pokemon? = nil
    @State private var selectedPokemonDetails: PokemonDetails? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.pokemonList, id: \.id) { pokemon in
                        PokemonItemView(pokemon: pokemon, viewModel: viewModel)
                            .onTapGesture {
                                selectedPokemon = pokemon
                                selectedPokemonDetails = viewModel.pokemonDetails(for: pokemon)
                            }
                    }
                }
            }
            .onAppear {
                viewModel.fetchData()
            }
            .navigationTitle("PokeDex")
            .sheet(item: $selectedPokemonDetails) { details in
                PokemonDetailView(pokemonDetails: details)
            }

            
        }
    }
}












struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



