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
    @StateObject private var viewModel = PokemonListViewModel()
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if let pokemonPage = pokemonPage {
                PokemonGridView(pokemonPage: pokemonPage, viewModel: viewModel)
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
    @ObservedObject var viewModel: PokemonListViewModel
    
    var body: some View {
        let columns = [GridItem(), GridItem()]
        return LazyVGrid(columns: columns) {
            ForEach(pokemonPage.results, id: \.id) { pokemon in
                PokemonItemViewContainer(pokemon: pokemon, viewModel: viewModel)
            }
        }
    }
}

struct PokemonItemViewContainer: View {
    let pokemon: Pokemon
    @ObservedObject var viewModel: PokemonListViewModel
    
    var body: some View {
        if let details = viewModel.pokemonDetails[pokemon.name] {
            return PokemonItemView(pokemonDetails: details)
                .onAppear {
                    viewModel.fetchPokemonDetails(for: pokemon)
                }
                .eraseToAnyView()
        } else {
            return PokemonItemViewPlaceholder()
                .onAppear {
                    viewModel.fetchPokemonDetails(for: pokemon)
                }
                .eraseToAnyView()
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







    
    
    
    









