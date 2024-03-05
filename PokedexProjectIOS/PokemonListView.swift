//
//  PokemonListView.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-05.
//

import SwiftUI
import Combine



import SwiftUI
import Combine




struct PokemonListView: View {
    @State private var pokemonPage: PokemonPage?
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if let pokemonPage = pokemonPage {
                let columns = [GridItem(), GridItem()]
                LazyVGrid(columns: columns) {
                    ForEach(pokemonPage.results) { pokemon in
                        PokemonItemView(pokemon: pokemon)
                    }
                }
            } else {
                Text("No data available")
            }
        }
        .onAppear {
            fetchData()
        }
    }
    
    private func fetchData() {
        isLoading = true
        
        // Assuming you have some method to fetch the Pokemon data
        // Here's a placeholder for demonstration purposes
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let samplePokemon = Pokemon(id: UUID(), name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25")
            let samplePokemonPage = PokemonPage(count: 1, next: "", results: [samplePokemon])
            pokemonPage = samplePokemonPage
            isLoading = false
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}







