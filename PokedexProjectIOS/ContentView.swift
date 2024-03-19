//
//  ContentView.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-05.
//

import SwiftUI
import Combine
struct ContentView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    @State private var isShowingPokemonDetails = false
    
    let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150), spacing: 10)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                    ForEach(viewModel.pokemonList, id: \.id) { pokemon in
                        PokemonItemViewContainer(pokemon: pokemon, viewModel: viewModel)
                            .onTapGesture {
                                viewModel.selectedPokemon = pokemon
                                viewModel.fetchPokemonDetails(for: pokemon)
                                isShowingPokemonDetails = true
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("PokeDex")
        }
        .sheet(isPresented: $isShowingPokemonDetails) {
            if let selectedPokemon = viewModel.selectedPokemon,
               let pokemonDetails = viewModel.pokemonDetails[selectedPokemon.name] {
                PokemonDetailView(pokemonDetails: pokemonDetails)
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



