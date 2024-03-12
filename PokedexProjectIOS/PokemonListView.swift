//
//  PokemonListView.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-05.
//

import SwiftUI
import Combine





struct PokemonListView: View {
    @State private var pokemonPage: PokemonPage?
    @State private var isLoading = false
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        Group {
            if isLoading {
               ProgressView()
            } else if let pokemonPage = pokemonPage {
                PokemonGridView(pokemonPage: pokemonPage, selectedPokemon: $viewModel.selectedPokemon, viewModel: viewModel)
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
        
        NetworkManager.shared.fetchPokemonPage { result in
            isLoading = false
            switch result {
            case .success(let pokemonPage):
                self.pokemonPage = pokemonPage
            case .failure(let error):
                print("Error fetching Pokemon: \(error)")
                // Handle error, e.g., show an alert
            }
        }
    }
}


    // Define a separate view for the grid
struct PokemonGridView: View {
    let pokemonPage: PokemonPage
    @Binding var selectedPokemon: Pokemon? // Update the type to PokemonDetails?
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        let columns = [GridItem(), GridItem()]
        return LazyVGrid(columns: columns) {
            ForEach(pokemonPage.results, id: \.id) { pokemon in
                PokemonItemView(pokemon: pokemon, viewModel: viewModel)

            }
        }
    }
}






    
    
    
    









